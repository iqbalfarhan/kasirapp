/// Hasil kalkulasi checkout (lihat PLAN §1 untuk urutan resmi).
class CheckoutResult {
  const CheckoutResult({
    required this.subtotalGross,
    required this.itemDiscountTotal,
    required this.subtotalAfterItemDiscount,
    required this.receiptDiscount,
    required this.subtotalAfterDiscount,
    required this.tax,
    required this.total,
    required this.payment,
    required this.change,
  });

  final int subtotalGross;
  final int itemDiscountTotal;
  final int subtotalAfterItemDiscount;
  final int receiptDiscount;
  final int subtotalAfterDiscount;
  final int tax;
  final int total;
  final int payment;
  final int change;
}
