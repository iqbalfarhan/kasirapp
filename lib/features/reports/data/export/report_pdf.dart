import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// PDF ringkasan laporan (A4). Murni dari [ReportData] — testable via angka.
Future<Uint8List> buildReportPdf({
  required ReportData data,
  required StoreSettings store,
}) async {
  final doc = pw.Document();
  final dayFmt = DateFormat('dd/MM/yyyy', 'id_ID');
  final range =
      '${dayFmt.format(data.start)} - ${dayFmt.format(data.end)}';
  final s = data.summary;

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
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Text(store.storeName,
            style: pw.TextStyle(
                fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Text('Laporan Penjualan - $range'),
        pw.SizedBox(height: 12),
        pw.Text('Ringkasan',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        kv('Omzet kotor', formatRp(s.gross)),
        kv('Total diskon', '- ${formatRp(s.totalDiscount)}'),
        kv('Pajak terkumpul', formatRp(s.taxCollected)),
        kv('Omzet bersih', formatRp(s.net), bold: true),
        kv('Jumlah transaksi', '${s.transactionCount}'),
        kv('Rata-rata struk', formatRp(s.averageTicket)),
        pw.SizedBox(height: 12),
        pw.Text('Harian',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.TableHelper.fromTextArray(
          headers: ['Tanggal', 'Trx', 'Kotor', 'Bersih'],
          data: [
            for (final d in data.daily)
              [
                dayFmt.format(d.date),
                '${d.count}',
                formatRp(d.gross),
                formatRp(d.net),
              ],
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Text('Produk Terlaris',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.TableHelper.fromTextArray(
          headers: ['Produk', 'Qty', 'Omzet'],
          data: [
            for (final p in data.topProducts)
              [p.name, '${p.qty}', formatRp(p.gross)],
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Text('Metode Bayar',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.TableHelper.fromTextArray(
          headers: ['Metode', 'Trx', 'Total'],
          data: [
            for (final p in data.payments)
              [p.method.toUpperCase(), '${p.count}', formatRp(p.total)],
          ],
        ),
      ],
    ),
  );
  return doc.save();
}
