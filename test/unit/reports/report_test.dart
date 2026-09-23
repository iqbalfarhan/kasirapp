import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/period.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/reports/data/export/report_csv.dart';
import 'package:kasirapp/features/reports/data/repositories/report_repository_impl.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/reports/domain/usecases/get_report.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Agregasi laporan (memory DB): angka manual, void exclude, bucket, terlaris.
void main() {
  late AppDatabase db;
  late ReportRepositoryImpl repo;

  Future<String> insertTx({
    required DateTime at,
    required String method,
    required int subtotal,
    required int tax,
    required int total,
    String status = 'sukses',
    List<(String, String, int, int)> items = const [],
  }) async {
    final id = _uuid.v4();
    await db.into(db.transactions).insert(TransactionsCompanion.insert(
          id: id,
          kasirId: 'k1',
          subtotal: subtotal,
          diskonItem: 0,
          pajakNilai: Value(tax),
          total: total,
          bayar: total,
          kembalian: 0,
          metode: method,
          status: Value(status),
          createdAt: at.millisecondsSinceEpoch,
        ));
    for (final (pid, name, price, qty) in items) {
      await db.into(db.transactionItems).insert(
            TransactionItemsCompanion.insert(
              id: _uuid.v4(),
              transactionId: id,
              productId: pid,
              namaSnapshot: name,
              hargaSnapshot: price,
              qty: qty,
              subtotal: price * qty,
            ),
          );
    }
    return id;
  }

  DateRange monthOf(DateTime ref) =>
      resolvePeriod(ReportPeriodType.month, now: ref);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ReportRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('range kosong → nol semua', () async {
    final range = monthOf(DateTime(2026, 5, 15));
    final r = await GetReport(repo)(
        GetReportParams(start: range.start, end: range.end));
    final data = (r as Success<ReportData>).data;
    expect(data.summary.transactionCount, 0);
    expect(data.summary.net, 0);
    expect(data.daily, isEmpty);
  });

  test('angka manual + void exclude + bucket + terlaris + metode', () async {
    // Hari 1: 2 kopi tunai. Hari 2: 1 cukur qris + 1 kopi lalu void.
    final day1 = DateTime(2026, 5, 10, 10);
    final day2 = DateTime(2026, 5, 11, 10);
    await insertTx(
      at: day1,
      method: 'tunai',
      subtotal: 20000,
      tax: 2000,
      total: 22000,
      items: [('p1', 'Kopi', 10000, 2)],
    );
    await insertTx(
      at: day2,
      method: 'qris',
      subtotal: 25000,
      tax: 2500,
      total: 27500,
      items: [('j1', 'Cukur', 25000, 1)],
    );
    await insertTx(
      at: day2,
      method: 'tunai',
      subtotal: 10000,
      tax: 1000,
      total: 11000,
      status: 'batal',
      items: [('p1', 'Kopi', 10000, 1)],
    );

    final range = monthOf(DateTime(2026, 5, 15));
    final r = await GetReport(repo)(
        GetReportParams(start: range.start, end: range.end));
    final data = (r as Success<ReportData>).data;
    final s = data.summary;

    expect(s.gross, 45000);
    expect(s.totalDiscount, 0);
    expect(s.taxCollected, 4500);
    expect(s.net, 49500);
    expect(s.transactionCount, 2);
    expect(s.averageTicket, 24750);

    expect(data.daily, hasLength(2));
    expect(data.daily[0].count, 1);
    expect(data.daily[1].net, 27500);

    expect(data.topProducts, hasLength(2));
    expect(data.topProducts[0].name, 'Kopi');
    expect(data.topProducts[0].qty, 2);
    expect(data.topProducts[1].name, 'Cukur');

    expect(data.payments, hasLength(2));
    final tunai =
        data.payments.firstWhere((e) => e.method == 'tunai');
    expect(tunai.total, 22000);
  });

  test('akhir < awal ditolak', () async {
    final r = await GetReport(repo)(GetReportParams(
      start: DateTime(2026, 5, 2),
      end: DateTime(2026, 5, 1),
    ));
    expect(r, isA<FailureResult<ReportData>>());
  });

  test('CSV: header + 1 baris + item deskripsi', () {
    final txDated = Transaction(
      id: 'abc',
      cashierId: 'k1',
      subtotal: 10000,
      itemDiscountTotal: 0,
      receiptDiscountType: DiscountType.none,
      receiptDiscountValue: 0,
      receiptDiscountTotal: 0,
      taxPercent: 10,
      taxTotal: 1000,
      total: 11000,
      payment: 11000,
      change: 0,
      paymentMethod: 'tunai',
      createdAt: DateTime(2026, 5, 10),
      items: [
        TransactionItem(
          productId: 'p1',
          nameSnapshot: 'Kopi',
          unitPriceSnapshot: 10000,
          qty: 1,
          subtotal: 10000,
        ),
      ],
    );
    final csv = buildTransactionsCsv([txDated]);
    final lines = csv.trim().split('\n');
    expect(lines, hasLength(2));
    expect(lines.first, contains('total'));
    expect(lines.last, contains('Kopi x1 @10000'));
    expect(lines.last, contains('11000'));
  });
}
