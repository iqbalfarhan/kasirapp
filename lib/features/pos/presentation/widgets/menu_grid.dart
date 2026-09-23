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
                  final cols = w < 400 ? 2 : (w < 700 ? 3 : 4);
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final p = items[i];
                      final outOfStock =
                          p.trackStock && p.stock <= 0;
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: outOfStock
                              ? () => showError(context,
                                  'Stok ${p.name} habis')
                              : () {
                                  final msg = ref
                                      .read(cartProvider.notifier)
                                      .addProduct(p);
                                  if (msg != null && context.mounted) {
                                    showError(context, msg);
                                  }
                                },
                          child: Opacity(
                            opacity: outOfStock ? 0.55 : 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: ProductImageThumb(
                                      path: p.imagePath,
                                      size: 56,
                                      borderRadius: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatRp(p.price),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    p.isService
                                        ? 'Jasa'
                                        : (outOfStock
                                            ? 'Habis'
                                            : 'Stok ${p.stock}'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
