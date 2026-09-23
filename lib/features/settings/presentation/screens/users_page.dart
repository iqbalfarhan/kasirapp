import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/usecases/create_user.dart';
import 'package:kasirapp/features/settings/domain/usecases/toggle_user_active.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';

/// Daftar pengguna + tambah + nonaktif. Hanya admin (dijaga router + widget).
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(isAdminProvider)) {
      return const Center(child: Text('Hanya admin.'));
    }
    final users = ref.watch(usersProvider);
    final me = ref.watch(authProvider);

    return Scaffold(
      body: users.when(
        data: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final u = items[i];
            final isMe = u.id == me?.id;
            return ListTile(
              leading: CircleAvatar(
                child: Icon(
                    u.isAdmin ? Icons.admin_panel_settings : Icons.person),
              ),
              title: Text('${u.name}${isMe ? ' (saya)' : ''}'),
              subtitle: Text(u.isAdmin ? 'Admin' : 'Kasir'),
              trailing: isMe
                  ? const Text('—')
                  : Switch(
                      value: u.isActive,
                      onChanged: (v) =>
                          _toggle(context, ref, u.id, v),
                    ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddUserDialog(context, ref),
        tooltip: 'Tambah pengguna',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggle(
      BuildContext context, WidgetRef ref, String id, bool v) async {
    final repo = ref.read(userRepositoryProvider);
    final result = await ToggleUserActive(repo)(
        ToggleUserActiveParams(id: id, isActive: v));
    if (!context.mounted) return;
    switch (result) {
      case Success():
        ref.invalidate(usersProvider);
        showOk(context, 'Status pengguna diubah');
      case FailureResult():
        showError(context, result.failure.message);
    }
  }
}

Future<void> showAddUserDialog(BuildContext context, WidgetRef ref) {
  final name = TextEditingController();
  final pin = TextEditingController();
  var role = UserRole.cashier;

  return showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Tambah Pengguna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nama*'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<UserRole>(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'Peran'),
              items: const [
                DropdownMenuItem(
                    value: UserRole.cashier, child: Text('Kasir')),
                DropdownMenuItem(
                    value: UserRole.admin, child: Text('Admin')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => role = v);
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pin,
              decoration:
                  const InputDecoration(labelText: 'PIN (4-6 digit)*'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
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
              final repo = ref.read(userRepositoryProvider);
              final result = await CreateUser(repo)(CreateUserParams(
                name: name.text,
                role: role,
                pin: pin.text.trim(),
              ));
              if (!ctx.mounted) return;
              switch (result) {
                case Success():
                  Navigator.pop(ctx);
                  ref.invalidate(usersProvider);
                  if (context.mounted) showOk(context, 'Pengguna ditambah');
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
