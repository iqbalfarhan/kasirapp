import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/product_image.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/pos/presentation/providers/cart_providers.dart';
import 'package:kasirapp/features/products/presentation/providers/product_providers.dart';

final _menuQueryProvider = StateProvider<String>((ref) => '');

/// Grid menu aktif. HP 2 kolom, tablet 3–4 kolom.
/// Tap = masuk keranjang (snapshot harga). Stok habis diblokir.
class MenuGrid extends ConsumerWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_menuQueryProvider);
    // Sengaja TIDAK memakai productListProvider: provider itu terpengaruh
    // filter admin (Setting/Menu). Kasir selalu tampil semua + search lokal.
    final list = ref.watch(posMenuListProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari menu...',
            ),
            onChanged: (v) =>
                ref.read(_menuQueryProvider.notifier).state = v,
          ),
        ),
        Expanded(
          child: list.when(
            data: (products) {
              final q = query.trim().toLowerCase();
              final items = products
                  .where((p) => p.isActive)
                  .where((p) =>
                      q.isEmpty ||
                      p.name.toLowerCase().contains(q) ||
                      p.effectiveCategory.toLowerCase().contains(q))
                  .toList();
              if (items.isEmpty) {
                return const Center(child: Text('Tidak ada menu aktif.'));
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  // Adaptif 2-4 kolom, target ~180px/card agar tiap
                  // resize signifikan pindah bucket (kasus split tablet
                  // Linux: lebar grid ~= 0.6 x window).
                  final cols = (w / 180).floor().clamp(2, 4);
                  const spacing = 8.0;
                  const horizontalPadding = 24.0; // 12 kiri + 12 kanan
                  final itemWidth =
                      (w - horizontalPadding - spacing * (cols - 1)) /
                      cols;
                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Wrap(
                      key: ValueKey(cols),
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final p in items)
                          SizedBox(
                            width: itemWidth,
                            child: _MenuCard(
                              name: p.name,
                              priceLabel: formatRp(p.price),
                              stockLabel: p.isService
                                  ? 'Jasa'
                                  : (p.trackStock && p.stock <= 0
                                        ? 'Habis'
                                        : 'Stok ${p.stock}'),
                              outOfStock:
                                  p.trackStock && p.stock <= 0,
                              imagePath: p.imagePath,
                              onTap: () {
                                if (p.trackStock && p.stock <= 0) {
                                  showError(
                                    context,
                                    'Stok ${p.name} habis',
                                  );
                                } else {
                                  final msg = ref
                                      .read(cartProvider.notifier)
                                      .addProduct(p);
                                  if (msg != null &&
                                      context.mounted) {
                                    showError(context, msg);
                                  }
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Gagal memuat: $e')),
          ),
        ),
      ],
    );
  }
}

/// Kartu menu: gambar square full-width di atas, teks fit-content di bawah.
class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.name,
    required this.priceLabel,
    required this.stockLabel,
    required this.outOfStock,
    required this.imagePath,
    required this.onTap,
  });

  final String name;
  final String priceLabel;
  final String stockLabel;
  final bool outOfStock;
  final String? imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: outOfStock ? 0.55 : 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductImageSquare(path: imagePath, borderRadius: 0),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priceLabel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stockLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
