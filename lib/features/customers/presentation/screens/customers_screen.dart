import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';
import 'package:kasirapp/features/customers/domain/usecases/save_customer.dart';
import 'package:kasirapp/features/customers/presentation/providers/customer_providers.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Master pelanggan: list + search + tambah/ubah.
class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(customerListProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari nama / HP...',
              ),
              onChanged: (v) =>
                  ref.read(customerQueryProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: list.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                      child: Text('Belum ada pelanggan.'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final c = items[i];
                    return ListTile(
                      leading: const CircleAvatar(
                          child: Icon(Icons.person)),
                      title: Text(c.name),
                      subtitle: Text(
                        [c.phone, c.address]
                            .where((e) =>
                                e != null && e.trim().isNotEmpty)
                            .join(' • '),
                      ),
                      onTap: () =>
                          showCustomerForm(context, ref, existing: c),
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
        onPressed: () => showCustomerForm(context, ref),
        tooltip: 'Tambah pelanggan',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> showCustomerForm(BuildContext context, WidgetRef ref,
    {Customer? existing}) {
  final name = TextEditingController(text: existing?.name ?? '');
  final phone = TextEditingController(text: existing?.phone ?? '');
  final address = TextEditingController(text: existing?.address ?? '');

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
          existing == null ? 'Tambah Pelanggan' : 'Ubah Pelanggan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Nama*'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: phone,
            decoration: const InputDecoration(labelText: 'HP'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: address,
            decoration: const InputDecoration(labelText: 'Alamat'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            final customer = Customer(
              id: existing?.id ?? _uuid.v4(),
              name: name.text,
              phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
              address:
                  address.text.trim().isEmpty ? null : address.text.trim(),
            );
            final repo = ref.read(customerRepositoryProvider);
            final result = await SaveCustomer(repo)(customer);
            if (!ctx.mounted) return;
            switch (result) {
              case Success():
                Navigator.pop(ctx);
                ref.invalidate(customerListProvider);
                if (context.mounted) showOk(context, 'Pelanggan tersimpan');
              case FailureResult():
                showError(ctx, result.failure.message);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}
