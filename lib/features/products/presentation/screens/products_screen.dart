import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/products/domain/usecases/save_product.dart';
import 'package:kasirapp/features/products/domain/usecases/toggle_product_active.dart';
import 'package:kasirapp/features/products/presentation/providers/product_providers.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Daftar menu + search + filter kategori + tambah/ubah + nonaktif.
/// Tanpa hapus permanen (keputusan review).
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(productListProvider);
    final categories = ref.watch(productCategoriesProvider);
    final selected = ref.watch(productCategoryProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari menu...',
              ),
              onChanged: (v) =>
                  ref.read(productQueryProvider.notifier).state = v,
            ),
          ),
          SizedBox(
            height: 44,
            child: categories.when(
              data: (cats) => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ChoiceChip(
                    label: const Text('Semua'),
                    selected: selected == null,
                    onSelected: (_) => ref
                        .read(productCategoryProvider.notifier)
                        .state = null,
                  ),
                  for (final c in cats) ...[
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(c),
                      selected: selected == c,
                      onSelected: (_) => ref
                          .read(productCategoryProvider.notifier)
                          .state = c,
                    ),
                  ],
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: list.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                      child: Text('Belum ada menu. Tambah via tombol +'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return Opacity(
                      opacity: p.isActive ? 1 : 0.5,
                      child: ListTile(
                        title: Text(p.name),
                        subtitle: Text(
                          '${p.effectiveCategory} • ${formatRp(p.price)} • '
                          '${p.isService ? 'Jasa' : 'Stok ${p.stock}'}',
                        ),
                        trailing: Switch(
                          value: p.isActive,
                          onChanged: (v) =>
                              _toggleActive(context, ref, p, v),
                        ),
                        onTap: () =>
                            showProductForm(context, ref, existing: p),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductForm(context, ref),
        tooltip: 'Tambah menu',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggleActive(
      BuildContext context, WidgetRef ref, Product p, bool v) async {
    final repo = ref.read(productRepositoryProvider);
    final result = await ToggleProductActive(repo)(
        ToggleProductActiveParams(id: p.id, isActive: v));
    if (!context.mounted) return;
    switch (result) {
      case Success():
        ref.invalidate(productListProvider);
        showOk(context, v ? 'Menu diaktifkan' : 'Menu dinonaktifkan');
      case FailureResult():
        showError(context, result.failure.message);
    }
  }
}

Future<void> showProductForm(BuildContext context, WidgetRef ref,
    {Product? existing}) {
  final name = TextEditingController(text: existing?.name ?? '');
  final category = TextEditingController(text: existing?.category ?? '');
  final price = TextEditingController(
      text: existing == null ? '' : existing.price.toString());
  final stock = TextEditingController(
      text: existing == null ? '' : existing.stock.toString());
  final image = TextEditingController(text: existing?.imagePath ?? '');
  var trackStock = existing?.trackStock ?? true;
  var isActive = existing?.isActive ?? true;

  return showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(existing == null ? 'Tambah Menu' : 'Ubah Menu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Nama*'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: category,
                decoration: const InputDecoration(
                    labelText: 'Kategori (kosong = Lainnya)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: price,
                decoration:
                    const InputDecoration(labelText: 'Harga (Rp)*'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Lacak stok'),
                subtitle: const Text('Matikan untuk jasa'),
                value: trackStock,
                onChanged: (v) => setState(() => trackStock = v),
              ),
              if (trackStock)
                TextField(
                  controller: stock,
                  decoration:
                      const InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                ),
              TextField(
                controller: image,
                decoration: const InputDecoration(
                    labelText: 'Path gambar (opsional)'),
              ),
              if (existing != null)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aktif'),
                  value: isActive,
                  onChanged: (v) => setState(() => isActive = v),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final product = Product(
                id: existing?.id ?? _uuid.v4(),
                name: name.text,
                category: category.text,
                price: parseRp(price.text),
                stock: trackStock
                    ? int.tryParse(stock.text) ?? 0
                    : 0,
                trackStock: trackStock,
                imagePath: image.text.trim().isEmpty
                    ? null
                    : image.text.trim(),
                isActive: isActive,
              );
              final repo = ref.read(productRepositoryProvider);
              final result =
                  await SaveProduct(repo)(product);
              if (!ctx.mounted) return;
              switch (result) {
                case Success():
                  Navigator.pop(ctx);
                  ref.invalidate(productListProvider);
                  ref.invalidate(productCategoriesProvider);
                  if (context.mounted) {
                    showOk(context, 'Menu tersimpan');
                  }
                case FailureResult():
                  showError(ctx, result.failure.message);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ),
  );
}
