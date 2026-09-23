class ReportSummary {
  const ReportSummary({
    required this.gross,
    required this.totalDiscount,
    required this.taxCollected,
    required this.net,
    required this.transactionCount,
    required this.averageTicket,
  });

  final int gross;
  final int totalDiscount;
  final int taxCollected;
  final int net;
  final int transactionCount;
  final int averageTicket;
}
