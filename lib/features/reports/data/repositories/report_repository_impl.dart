import 'package:drift/drift.dart';
import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/reports/domain/entities/report_summary.dart';
import 'package:kasirapp/features/reports/domain/repositories/report_repository.dart';

/// Agregasi laporan dari snapshot transaksi. Hanya status sukses.
class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<Result<ReportData>> getReport(
      {required DateTime start, required DateTime end}) async {
    try {
      final startMs = start.millisecondsSinceEpoch;
      final endMs = end.millisecondsSinceEpoch;

      final headers = await (_db.select(_db.transactions)
            ..where((t) =>
                t.createdAt.isBiggerOrEqualValue(startMs) &
                t.createdAt.isSmallerOrEqualValue(endMs) &
                t.status.equals('sukses'))
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();

      if (headers.isEmpty) {
        return Success(ReportData.empty(start: start, end: end));
      }

      var gross = 0;
      var itemDisc = 0;
      var receiptDisc = 0;
      var tax = 0;
      var net = 0;
      final daily = <DateTime, _Day>{};
      final payments = <String, _Pay>{};

      for (final h in headers) {
        final rDisc =
            h.subtotal - h.diskonItem - (h.total - h.pajakNilai);
        gross += h.subtotal;
        itemDisc += h.diskonItem;
        receiptDisc += rDisc;
        tax += h.pajakNilai;
        net += h.total;

        final day = DateTime.fromMillisecondsSinceEpoch(h.createdAt);
        final key = DateTime(day.year, day.month, day.day);
        final d = daily[key] ?? _Day();
        d.gross += h.subtotal;
        d.net += h.total;
        d.count += 1;
        daily[key] = d;

        final p = payments[h.metode] ?? _Pay();
        p.count += 1;
        p.total += h.total;
        payments[h.metode] = p;
      }

      // Produk terlaris dari snapshot item transaksi sukses.
      final ids = headers.map((e) => e.id).toList();
      final items = await (_db.select(_db.transactionItems)
            ..where((t) => t.transactionId.isIn(ids)))
          .get();
      final byProduct = <String, _Prod>{};
      for (final it in items) {
        final p = byProduct[it.productId] ??
            _Prod(name: it.namaSnapshot);
        p.qty += it.qty;
        p.gross += it.subtotal;
        byProduct[it.productId] = p;
      }
      final top = byProduct.entries
          .map((e) => TopProduct(
                productId: e.key,
                name: e.value.name,
                qty: e.value.qty,
                gross: e.value.gross,
              ))
          .toList()
        ..sort((a, b) => b.qty.compareTo(a.qty));

      final count = headers.length;
      return Success(ReportData(
        start: start,
        end: end,
        summary: ReportSummary(
          gross: gross,
          totalDiscount: itemDisc + receiptDisc,
          taxCollected: tax,
          net: net,
          transactionCount: count,
          averageTicket: count == 0 ? 0 : net ~/ count,
        ),
        daily: [
          for (final e in daily.entries)
            DailyTotal(
                date: e.key,
                gross: e.value.gross,
                net: e.value.net,
                count: e.value.count),
        ]..sort((a, b) => a.date.compareTo(b.date)),
        topProducts: top.take(5).toList(),
        payments: [
          for (final e in payments.entries)
            PaymentBreakdown(
                method: e.key, count: e.value.count, total: e.value.total),
        ]..sort((a, b) => b.total.compareTo(a.total)),
      ));
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal memuat laporan: $e'));
    }
  }
}

class _Day {
  int gross = 0;
  int net = 0;
  int count = 0;
}

class _Pay {
  int count = 0;
  int total = 0;
}

class _Prod {
  _Prod({required this.name});
  final String name;
  int qty = 0;
  int gross = 0;
}
