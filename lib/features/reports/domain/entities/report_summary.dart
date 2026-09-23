class ReportSummary {
  const ReportSummary({
    required this.gross,
    required this.totalDiscount,
    required this.taxCollected,
    required this.net,
    required this.transactionCount,
    required this.averageTicket,
  });

  /// Kosong (tanpa transaksi) — semua nol.
  const ReportSummary.empty()
      : gross = 0,
        totalDiscount = 0,
        taxCollected = 0,
        net = 0,
        transactionCount = 0,
        averageTicket = 0;

  final int gross;
  final int totalDiscount;
  final int taxCollected;
  final int net;
  final int transactionCount;
  final int averageTicket;
}

/// Agregat per hari (bucket tanggal) untuk grafik batang.
class DailyTotal {
  const DailyTotal({
    required this.date,
    required this.gross,
    required this.net,
    required this.count,
  });

  final DateTime date;
  final int gross;
  final int net;
  final int count;
}

/// Produk terlaris berdasarkan qty (dari snapshot item).
class TopProduct {
  const TopProduct({
    required this.productId,
    required this.name,
    required this.qty,
    required this.gross,
  });

  final String productId;
  final String name;
  final int qty;
  final int gross;
}

/// Breakdown per metode bayar.
class PaymentBreakdown {
  const PaymentBreakdown({
    required this.method,
    required this.count,
    required this.total,
  });

  final String method;
  final int count;
  final int total;
}

/// Paket laporan lengkap untuk satu rentang. Hanya status sukses.
class ReportData {
  const ReportData({
    required this.start,
    required this.end,
    required this.summary,
    required this.daily,
    required this.topProducts,
    required this.payments,
  });

  const ReportData.empty({required this.start, required this.end})
      : summary = const ReportSummary.empty(),
        daily = const [],
        topProducts = const [],
        payments = const [];

  final DateTime start;
  final DateTime end;
  final ReportSummary summary;
  final List<DailyTotal> daily;
  final List<TopProduct> topProducts;
  final List<PaymentBreakdown> payments;
}
