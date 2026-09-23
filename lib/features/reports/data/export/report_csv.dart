import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';

String _cell(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}

/// CSV detail transaksi (satu baris per transaksi + ringkasan item).
/// Murni Dart — diunit-test langsung.
String buildTransactionsCsv(List<Transaction> transactions) {
  final buf = StringBuffer();
  buf.writeln([
    'id',
    'tanggal',
    'kasir_id',
    'pelanggan_id',
    'subtotal',
    'diskon_item',
    'diskon_struk_tipe',
    'diskon_struk_nilai',
    'pajak_persen',
    'pajak',
    'total',
    'bayar',
    'kembalian',
    'metode',
    'status',
    'item_count',
    'items',
  ].map(_cell).join(','));

  for (final tx in transactions) {
    final itemsDesc = tx.items
        .map((e) => '${e.nameSnapshot} x${e.qty} @${e.unitPriceSnapshot}')
        .join('; ');
    buf.writeln([
      _cell(tx.id),
      _cell(tx.createdAt.toIso8601String()),
      _cell(tx.cashierId),
      _cell(tx.customerId ?? ''),
      '${tx.subtotal}',
      '${tx.itemDiscountTotal}',
      _cell(tx.receiptDiscountType.name),
      '${tx.receiptDiscountValue}',
      '${tx.taxPercent}',
      '${tx.taxTotal}',
      '${tx.total}',
      '${tx.payment}',
      '${tx.change}',
      _cell(tx.paymentMethod),
      _cell(tx.isVoided ? 'batal' : 'sukses'),
      '${tx.items.length}',
      _cell(itemsDesc),
    ].join(','));
  }
  return buf.toString();
}
