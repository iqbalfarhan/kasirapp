import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Struk 80mm dari snapshot transaksi (tidak ikut master/settings live).
/// Dipakai cetak ulang riwayat (Fase 3) dan checkout (Fase 5).
Future<Uint8List> buildReceiptPdf({
  required Transaction tx,
  required StoreSettings store,
  String? cashierName,
  String? customerName,
}) async {
  final doc = pw.Document();
  final date =
      DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(tx.createdAt);

  pw.Widget line() => pw.Container(
        height: 0.5,
        color: PdfColors.grey,
        margin: const pw.EdgeInsets.symmetric(vertical: 4),
      );

  pw.Widget kv(String label, String value, {bool bold = false}) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(value,
              style: pw.TextStyle(
                  fontWeight:
                      bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Center(
            child: pw.Text(store.storeName,
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ),
          if (store.address != null)
            pw.Center(child: pw.Text(store.address!)),
          if (store.phone != null)
            pw.Center(child: pw.Text(store.phone!)),
          line(),
          kv('No', '#${tx.id.substring(0, 8)}'),
          kv('Tanggal', date),
          kv('Kasir', cashierName ?? tx.cashierId),
          if (customerName != null) kv('Pelanggan', customerName),
          kv('Bayar', tx.paymentMethod.toUpperCase()),
          if (tx.isVoided) kv('STATUS', 'BATAL', bold: true),
          line(),
          for (final item in tx.items) ...[
            pw.Text('${item.nameSnapshot} x${item.qty}'),
            kv('  ${formatRp(item.unitPriceSnapshot)}',
                formatRp(item.subtotal)),
          ],
          line(),
          kv('Subtotal', formatRp(tx.subtotal)),
          if (tx.itemDiscountTotal > 0)
            kv('Diskon item', '- ${formatRp(tx.itemDiscountTotal)}'),
          if (tx.receiptDiscountTotal > 0)
            kv('Diskon struk', '- ${formatRp(tx.receiptDiscountTotal)}'),
          kv('Pajak (${tx.taxPercent}%)', formatRp(tx.taxTotal)),
          kv('TOTAL', formatRp(tx.total), bold: true),
          kv('Bayar', formatRp(tx.payment)),
          kv('Kembalian', formatRp(tx.change)),
          line(),
          pw.Center(child: pw.Text('Terima kasih!')),
          if (tx.isVoided && tx.voidReason != null)
            pw.Center(child: pw.Text('Void: ${tx.voidReason}')),
        ],
      ),
    ),
  );
  return doc.save();
}
