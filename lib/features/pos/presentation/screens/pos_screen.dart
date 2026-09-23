import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/responsive.dart';
import 'package:kasirapp/features/pos/presentation/providers/cart_providers.dart';
import 'package:kasirapp/features/pos/presentation/widgets/cart_panel.dart';
import 'package:kasirapp/features/pos/presentation/widgets/menu_grid.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';

/// Layar kasir: grid menu + keranjang.
/// HP: menu penuh + bar bawah buka keranjang. Tablet: split 3:2.
class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pajak live dari settings (snapshot saat checkout via cart).
    ref.listen(settingsProvider, (_, next) {
      next.whenData((s) {
        if (ref.read(cartProvider).taxPercent != s.taxPercent) {
          ref.read(cartProvider.notifier).setTaxPercent(s.taxPercent);
        }
      });
    });

    if (isTablet(context)) {
      return const Row(
        children: [
          Expanded(flex: 3, child: MenuGrid()),
          VerticalDivider(width: 1),
          Expanded(flex: 2, child: CartPanel()),
        ],
      );
    }

    final totals = ref.watch(cartTotalsProvider);
    final count = ref.watch(cartProvider.select((c) => c.items.length));

    return Scaffold(
      appBar: AppBar(title: Text("Pilih menu")),
      body: const MenuGrid(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.9,
                builder: (_, _) =>
                    CartPanel(onCheckoutDone: () => Navigator.pop(context)),
              ),
            ),
            child: Text(
              count == 0
                  ? 'Keranjang kosong'
                  : 'Keranjang ($count) • ${formatRp(totals.total)}',
            ),
          ),
        ),
      ),
    );
  }
}
