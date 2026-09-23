/// Jenis diskon seragam: per-item maupun per-struk.
enum DiscountType { none, percent, amount }

/// Nilai diskon: percent 0-100, amount dalam IDR.
class Discount {
  const Discount({this.type = DiscountType.none, this.value = 0});

  final DiscountType type;
  final int value;

  bool get isNone => type == DiscountType.none || value <= 0;
}
