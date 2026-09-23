import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/period.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/reports/data/export/report_csv.dart';
import 'package:kasirapp/features/reports/data/export/report_pdf.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/reports/presentation/providers/report_providers.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';
import 'package:kasirapp/features/transactions/presentation/providers/history_providers.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Laporan: periode + KPI + grafik + terlaris + metode + export.
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportProvider);
    final range = ref.watch(reportRangeProvider);

    Future<void> pickCustom() async {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        ref.read(reportCustomProvider.notifier).state = DateRange(
          start: picked.start,
          end: picked.end,
        );
        ref.read(reportRangeProvider.notifier).state =
            ReportRange.custom;
      }
    }

    Future<void> exportPdf(ReportData data) async {
      final store = await ref.read(settingsProvider.future);
      final bytes = await buildReportPdf(data: data, store: store);
      await Printing.sharePdf(
          bytes: bytes,
          filename:
              'laporan-${DateFormat('yyyyMMdd').format(data.start)}.pdf');
    }

    Future<void> exportCsv(ReportData data) async {
      final txResult = await ref
          .read(transactionRepositoryProvider)
          .getTransactions(start: data.start, end: data.end);
      if (!context.mounted) return;
      switch (txResult) {
        case FailureResult():
          showError(context, txResult.failure.message);
        case Success():
          final csv = buildTransactionsCsv(txResult.data);
          await Share.shareXFiles(
            [
              XFile.fromData(
                utf8.encode(csv),
                name:
                    'laporan-${DateFormat('yyyyMMdd').format(data.start)}.csv',
                mimeType: 'text/csv',
              ),
            ],
            text: 'Export laporan Kasirapp',
          );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                for (final r in ReportRange.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(switch (r) {
                        ReportRange.today => 'Hari ini',
                        ReportRange.week => 'Minggu ini',
                        ReportRange.month => 'Bulan ini',
                        ReportRange.year => 'Tahun ini',
                        ReportRange.custom => 'Custom',
                      }),
                      selected: range == r,
                      onSelected: (_) {
                        if (r == ReportRange.custom) {
                          pickCustom();
                        } else {
                          ref
                              .read(reportRangeProvider.notifier)
                              .state = r;
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: report.when(
              data: (data) => _Body(
                  data: data,
                  onPdf: () => exportPdf(data),
                  onCsv: () => exportCsv(data)),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gagal memuat: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(
      {required this.data, required this.onPdf, required this.onCsv});

  final ReportData data;
  final VoidCallback onPdf;
  final VoidCallback onCsv;

  @override
  Widget build(BuildContext context) {
    final s = data.summary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GridView.count(
          crossAxisCount:
              MediaQuery.sizeOf(context).shortestSide >= 600 ? 3 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.6,
          children: [
            _kpi('Omzet Bersih', formatRp(s.net)),
            _kpi('Omzet Kotor', formatRp(s.gross)),
            _kpi('Diskon', formatRp(s.totalDiscount)),
            _kpi('Pajak', formatRp(s.taxCollected)),
            _kpi('Transaksi', '${s.transactionCount}'),
            _kpi('Rata-rata', formatRp(s.averageTicket)),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Omzet Harian',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(height: 200, child: _Chart(daily: data.daily)),
        const SizedBox(height: 12),
        const Text('Produk Terlaris',
            style: TextStyle(fontWeight: FontWeight.bold)),
        if (data.topProducts.isEmpty)
          const Text('Belum ada data.')
        else
          for (final p in data.topProducts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(p.name),
              subtitle: Text('${p.qty} terjual'),
              trailing: Text(formatRp(p.gross)),
            ),
        const SizedBox(height: 8),
        const Text('Metode Bayar',
            style: TextStyle(fontWeight: FontWeight.bold)),
        if (data.payments.isEmpty)
          const Text('Belum ada data.')
        else
          for (final p in data.payments)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(p.method.toUpperCase()),
              subtitle: Text('${p.count} transaksi'),
              trailing: Text(formatRp(p.total)),
            ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPdf,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('PDF'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCsv,
                icon: const Icon(Icons.table_chart),
                label: const Text('CSV'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kpi(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.daily});

  final List<DailyTotal> daily;

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) {
      return const Center(child: Text('Belum ada data.'));
    }
    final maxY =
        daily.map((e) => e.net).reduce((a, b) => a > b ? a : b).toDouble();
    final step = (daily.length / 7).ceil().clamp(1, 31);
    return BarChart(
      BarChartData(
        maxY: maxY == 0 ? 1 : maxY * 1.1,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 ||
                    i >= daily.length ||
                    i % step != 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat('d/M').format(daily[i].date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < daily.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: daily[i].net.toDouble(),
                  color: Theme.of(context).colorScheme.primary,
                  width: 12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
