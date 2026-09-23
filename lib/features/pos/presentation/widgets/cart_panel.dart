import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/customers/presentation/providers/customer_providers.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';
import 'package:kasirapp/features/pos/presentation/providers/cart_providers.dart';
import 'package:kasirapp/features/pos/presentation/widgets/checkout_sheet.dart';
import 'package:kasirapp/features/pos/presentation/widgets/customer_picker.dart';
import 'package:kasirapp/features/pos/presentation/widgets/discount_dialog.dart';
import 'package:kasirapp/features/products/presentation/providers/product_providers.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';

/// Panel keranjang: item + stepper + diskon + pelanggan + total + Bayar.
class CartPanel extends ConsumerWidget {
  const CartPanel({super.key, this.onCheckoutDone});

  /// Dipanggil setelah checkout sukses (mis. tutup modal di HP).
  final VoidCallback? onCheckoutDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final totals = ref.watch(cartTotalsProvider);
    final customers = ref.watch(customerListProvider);
    final products = ref.watch(productListProvider);
    final settings = ref.watch(settingsProvider);
    final maxPct = settings.valueOrNull?.maxDiscountPercent ?? 20;
    final stockById = {
      for (final p in products.valueOrNull ?? []) p.id: p,
    };

    String customerLabel() {
      final id = cart.customerId;
      if (id == null) return 'Pelanggan umum';
      final list = customers.valueOrNull ?? [];
      for (final c in list) {
        if (c.id == id) return c.name;
      }
      return 'Pelanggan';
    }

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(customerLabel()),
          trailing: cart.customerId == null
              ? const Icon(Icons.chevron_right)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      ref.read(cartProvider.notifier).setCustomer(null),
                ),
          onTap: () async {
            final picked = await showCustomerPicker(context);
            if (!context.mounted) return;
            ref
                .read(cartProvider.notifier)
                .setCustomer(picked?.id);
          },
        ),
        const Divider(height: 1),
        Expanded(
          child: cart.items.isEmpty
              ? const Center(child: Text('Keranjang kosong'))
              : ListView.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = cart.items[i];
                    final stock = stockById[item.productId]?.stock;
                    final tracked =
                        stockById[item.productId]?.trackStock ?? false;
                    return InkWell(
                      onLongPress: () async {
                        final d = await showDiscountDialog(
                          context,
                          title: 'Diskon ${item.name}',
                          current: item.discount,
                          maxPercent: maxPct,
                        );
                        if (!context.mounted) return;
                        if (d != null) {
                          ref
                              .read(cartProvider.notifier)
                              .setItemDiscount(item.productId, d);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(formatRp(item.lineNet),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  visualDensity:
                                      VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                      minWidth: 32, minHeight: 32),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .removeItem(item.productId),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${formatRp(item.unitPrice)} × ${item.qty}'
                                    '${item.discount.isNone ? '' : ' • disc ${item.discount.type == DiscountType.percent ? '${item.discount.value}%' : formatRp(item.discount.value)}'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _stepBtn(
                                  context,
                                  icon: Icons.remove,
                                  onTap: () => ref
                                      .read(cartProvider.notifier)
                                      .setQty(
                                          item.productId, item.qty - 1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('${item.qty}'),
                                ),
                                _stepBtn(
                                  context,
                                  icon: Icons.add,
                                  onTap: () {
                                    final msg = ref
                                        .read(cartProvider.notifier)
                                        .setQty(
                                          item.productId,
                                          item.qty + 1,
                                          stockCap:
                                              tracked ? stock : null,
                                        );
                                    if (msg != null &&
                                        context.mounted) {
                                      showError(context, msg);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        const Divider(height: 1),
        ListTile(
          dense: true,
          leading: const Icon(Icons.discount),
          title: const Text('Diskon struk'),
          subtitle: cart.receiptDiscount.isNone
              ? null
              : Text(
                  cart.receiptDiscount.type == DiscountType.percent
                      ? '${cart.receiptDiscount.value}%'
                      : formatRp(cart.receiptDiscount.value),
                ),
          trailing: cart.receiptDiscount.isNone
              ? const Icon(Icons.chevron_right)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => ref
                      .read(cartProvider.notifier)
                      .setReceiptDiscount(const Discount()),
                ),
          onTap: () async {
            final d = await showDiscountDialog(
              context,
              title: 'Diskon Struk',
              current: cart.receiptDiscount,
              maxPercent: maxPct,
            );
            if (!context.mounted) return;
            if (d != null) {
              ref.read(cartProvider.notifier).setReceiptDiscount(d);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            children: [
              _row('Subtotal', formatRp(totals.subtotalGross)),
              if (totals.itemDiscountTotal > 0)
                _row('Diskon item',
                    '- ${formatRp(totals.itemDiscountTotal)}'),
              if (totals.receiptDiscount > 0)
                _row('Diskon struk',
                    '- ${formatRp(totals.receiptDiscount)}'),
              _row(
                  'Pajak (${cart.taxPercent}%)', formatRp(totals.tax)),
              const SizedBox(height: 4),
              _row(
                'Total',
                formatRp(totals.total),
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty
                    ? null
                    : () => openCheckoutSheet(context, ref,
                        onDone: onCheckoutDone),
                child: const Text('Bayar'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepBtn(BuildContext context,
      {required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 32,
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {TextStyle? style}) {
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
