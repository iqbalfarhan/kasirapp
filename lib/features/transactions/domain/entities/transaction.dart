import 'package:kasirapp/features/pos/domain/entities/discount.dart';

enum TransactionStatus { success, voided }

class TransactionItem {
  const TransactionItem({
    required this.productId,
    required this.nameSnapshot,
    required this.unitPriceSnapshot,
    required this.qty,
    required this.subtotal,
    this.discountType = DiscountType.none,
    this.discountValue = 0,
  });

  final String productId;
  final String nameSnapshot;
  final int unitPriceSnapshot;
  final int qty;
  final int subtotal;

  /// Snapshot diskon per-line saat checkout (tidak ikut master).
  final DiscountType discountType;
  final int discountValue;
}

/// Snapshot struk penuh: nilai saat checkout, tidak berubah saat
/// master produk / setting pajak & diskon berubah (PLAN §1 aturan 8).
class Transaction {
  const Transaction({
    required this.id,
    this.customerId,
    required this.cashierId,
    required this.subtotal,
    required this.itemDiscountTotal,
    required this.receiptDiscountType,
    required this.receiptDiscountValue,
    required this.receiptDiscountTotal,
    required this.taxPercent,
    required this.taxTotal,
    required this.total,
    required this.payment,
    required this.change,
    required this.paymentMethod,
    required this.createdAt,
    this.status = TransactionStatus.success,
    this.items = const [],
    this.voidReason,
    this.voidBy,
    this.voidAt,
  });

  final String id;
  final String? customerId;
  final String cashierId;
  final int subtotal;
  final int itemDiscountTotal;
  final DiscountType receiptDiscountType;
  final int receiptDiscountValue;
  final int receiptDiscountTotal;
  final int taxPercent;
  final int taxTotal;
  final int total;
  final int payment;
  final int change;
  final String paymentMethod;
  final DateTime createdAt;
  final TransactionStatus status;
  final List<TransactionItem> items;

  /// Audit void: wajib diisi saat status == voided.
  final String? voidReason;
  final String? voidBy;
  final DateTime? voidAt;

  bool get isVoided => status == TransactionStatus.voided;
}
