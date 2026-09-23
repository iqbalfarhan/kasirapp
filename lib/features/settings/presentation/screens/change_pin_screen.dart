import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/settings/domain/usecases/change_pin.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';

/// Wajib diisi saat `mustChangePin` (admin seed pertama kali).
class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final _pin1 = TextEditingController();
  final _pin2 = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _pin1.dispose();
    _pin2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = ref.read(authProvider);
    if (user == null) {
      context.go('/login');
      return;
    }
    if (_pin1.text.trim() != _pin2.text.trim()) {
      setState(() => _error = 'Konfirmasi PIN tidak sama');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final repo = ref.read(userRepositoryProvider);
    final result = await ChangePin(repo)(
        ChangePinParams(userId: user.id, newPin: _pin1.text.trim()));
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Success():
        ref.read(authProvider.notifier).markPinChanged();
        context.go('/kasir');
      case FailureResult():
        setState(() => _error = result.failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganti PIN')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'PIN default wajib diganti sebelum memakai kasir.'),
                const SizedBox(height: 16),
                TextField(
                  controller: _pin1,
                  decoration:
                      const InputDecoration(labelText: 'PIN baru (4-6 digit)'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _pin2,
                  decoration: const InputDecoration(
                      labelText: 'Ulangi PIN baru'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  onSubmitted: (_) => _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!,
                      style:
                          TextStyle(color: Colors.red.shade700)),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _submit,
                    child: const Text('Simpan PIN'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
