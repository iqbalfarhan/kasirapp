import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/features/customers/domain/entities/customer.dart';
import 'package:kasirapp/features/customers/presentation/providers/customer_providers.dart';

/// Pilih pelanggan (opsional) untuk struk. Null = pelanggan umum.
Future<Customer?> showCustomerPicker(BuildContext context) {
  return showDialog<Customer>(
    context: context,
    builder: (ctx) => const _CustomerPickerDialog(),
  );
}

class _CustomerPickerDialog extends ConsumerWidget {
  const _CustomerPickerDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(customerListProvider);
    return AlertDialog(
      title: const Text('Pilih Pelanggan'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari...',
              ),
              onChanged: (v) =>
                  ref.read(customerQueryProvider.notifier).state = v,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: list.when(
                data: (items) => ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Pelanggan umum'),
                      onTap: () => Navigator.pop(context),
                    ),
                    for (final c in items)
                      ListTile(
                        leading: const CircleAvatar(
                            child: Icon(Icons.person)),
                        title: Text(c.name),
                        subtitle:
                            c.phone == null ? null : Text(c.phone!),
                        onTap: () => Navigator.pop(context, c),
                      ),
                  ],
                ),
                loading: () => const Center(
                    child: CircularProgressIndicator()),
                error: (e, _) => Text('Gagal memuat: $e'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
