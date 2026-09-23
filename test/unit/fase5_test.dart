import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kasirapp/core/receipt_pdf.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/reports/data/export/report_pdf.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/settings/data/backup/backup_service.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';

/// Fase 5: PDF builder + backup service (tanpa plugin platform).
void main() {
  setUpAll(() => initializeDateFormatting('id_ID', null));

  const store = StoreSettings(
      storeName: 'Toko Uji', taxPercent: 10, address: 'Jl. Tes');

  Transaction sampleTx() => Transaction(
        id: 'tx-12345678',
        cashierId: 'k1',
        subtotal: 20000,
        itemDiscountTotal: 1000,
        receiptDiscountType: DiscountType.amount,
        receiptDiscountValue: 1000,
        receiptDiscountTotal: 1000,
        taxPercent: 10,
        taxTotal: 1800,
        total: 19800,
        payment: 20000,
        change: 200,
        paymentMethod: 'tunai',
        createdAt: DateTime(2026, 5, 10, 10),
        items: const [
          TransactionItem(
            productId: 'p1',
            nameSnapshot: 'Kopi',
            unitPriceSnapshot: 10000,
            qty: 2,
            subtotal: 19000,
          ),
        ],
      );

  test('struk PDF menghasilkan bytes', () async {
    final bytes = await buildReceiptPdf(
      tx: sampleTx(),
      store: store,
      cashierName: 'Admin',
    );
    expect(bytes.isNotEmpty, isTrue);
    // Header PDF.
    expect(String.fromCharCodes(bytes.sublist(0, 5)), '%PDF-');
  });

  test('struk batal tetap ter-generate', () async {
    final tx = sampleTx();
    final voided = Transaction(
      id: tx.id,
      cashierId: tx.cashierId,
      subtotal: tx.subtotal,
      itemDiscountTotal: tx.itemDiscountTotal,
      receiptDiscountType: tx.receiptDiscountType,
      receiptDiscountValue: tx.receiptDiscountValue,
      receiptDiscountTotal: tx.receiptDiscountTotal,
      taxPercent: tx.taxPercent,
      taxTotal: tx.taxTotal,
      total: tx.total,
      payment: tx.payment,
      change: tx.change,
      paymentMethod: tx.paymentMethod,
      createdAt: tx.createdAt,
      status: TransactionStatus.voided,
      items: tx.items,
      voidReason: 'salah',
    );
    final bytes =
        await buildReceiptPdf(tx: voided, store: store);
    expect(bytes.isNotEmpty, isTrue);
  });

  test('PDF laporan menghasilkan bytes', () async {
    final data = ReportData(
      start: rangeStart,
      end: rangeEnd,
      summary: const ReportSummary(
        gross: 45000,
        totalDiscount: 0,
        taxCollected: 4500,
        net: 49500,
        transactionCount: 2,
        averageTicket: 24750,
      ),
      daily: [],
      topProducts: [],
      payments: [],
    );
    final bytes = await buildReportPdf(data: data, store: store);
    expect(bytes.isNotEmpty, isTrue);
  });

  group('BackupService', () {
    const service = BackupService();
    late Directory tmp;

    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('kasirapp_test');
    });

    tearDown(() async {
      if (await tmp.exists()) await tmp.delete(recursive: true);
    });

    test('magic header SQLite dikenali', () {
      final valid = Uint8List.fromList(
          'SQLite format 3\x00................'.codeUnits);
      expect(service.isSqliteFile(valid), isTrue);
      expect(service.isSqliteFile(Uint8List.fromList([1, 2, 3])),
          isFalse);
      expect(
          service.isSqliteFile(
              Uint8List.fromList('bukan database'.codeUnits)),
          isFalse);
    });

    test('restore menyalin file valid, menolak invalid', () async {
      final src = File('${tmp.path}/src.sqlite');
      await src.writeAsBytes(Uint8List.fromList(
          'SQLite format 3\x00DATA................'.codeUnits));
      final dst = File('${tmp.path}/dst.sqlite');
      await service.restoreDatabase(source: src, target: dst);
      expect(await dst.exists(), isTrue);
      expect(await dst.length(), await src.length());

      final bad = File('${tmp.path}/bad.sqlite');
      await bad.writeAsString('bukan sqlite');
      await expectLater(
        service.restoreDatabase(source: bad, target: dst),
        throwsA(isA<FormatException>()),
      );
    });
  });
}

final rangeStart = DateTime(2026, 5, 1);
final rangeEnd = DateTime(2026, 5, 31, 23, 59, 59, 999);
