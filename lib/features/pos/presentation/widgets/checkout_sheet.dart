import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/receipt_pdf.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/pos/domain/usecases/checkout.dart';
import 'package:kasirapp/features/pos/presentation/providers/cart_providers.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';
import 'package:kasirapp/features/transactions/presentation/providers/history_providers.dart';
import 'package:printing/printing.dart';

void openCheckoutSheet(BuildContext context, WidgetRef ref,
    {VoidCallback? onDone}) {
  ref.read(paymentMethodProvider.notifier).state = 'tunai';
  ref.read(paymentInputProvider.notifier).state = 0;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: CheckoutSheet(onDone: onDone),
    ),
  );
}

const _quickAmounts = [10000, 20000, 50000, 100000];

/// Lembar bayar: metode + nominal cepat + input + kembalian live.
class CheckoutSheet extends ConsumerStatefulWidget {
  const CheckoutSheet({super.key, this.onDone});

  final VoidCallback? onDone;

  @override
  ConsumerState<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends ConsumerState<CheckoutSheet> {
  final _payment = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _payment.text = '';
  }

  @override
  void dispose() {
    _payment.dispose();
    super.dispose();
  }

  void _setPayment(int v) {
    ref.read(paymentInputProvider.notifier).state = v;
    _payment.text = v == 0 ? '' : v.toString();
  }

  Future<void> _pay(WidgetRef ref) async {
    final cart = ref.read(cartProvider);
    final user = ref.read(authProvider);
    final settings = await ref.read(settingsProvider.future);
    if (!mounted) return;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi habis, login ulang')),
      );
      return;
    }
    setState(() => _busy = true);
    final totals = ref.read(cartTotalsProvider);
    final method = ref.read(paymentMethodProvider);
    final payment =
        method == 'tunai' ? ref.read(paymentInputProvider) : totals.total;
    final repo = ref.read(posRepositoryProvider);
    final result = await Checkout(repo)(CheckoutParams(
      cart: cart,
      payment: payment,
      cashierId: user.id,
      paymentMethod: method,
      maxDiscountPercent: settings.maxDiscountPercent,
    ));
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Success():
        final txId = result.data;
        final change = payment - totals.total;
        ref.read(cartProvider.notifier).clear();
        ref.read(paymentInputProvider.notifier).state = 0;
        if (!mounted) return;
        Navigator.pop(context); // tutup sheet
        widget.onDone?.call();
        _showSuccess(txId, change);
      case FailureResult():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.failure.message)),
        );
    }
  }

  Future<void> _shareReceipt(String txId) async {
    try {
      final detail = await ref
          .read(transactionRepositoryProvider)
          .getDetail(txId);
      if (!mounted) return;
      switch (detail) {
        case FailureResult():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(detail.failure.message)),
          );
        case Success():
          final settings =
              await ref.read(settingsProvider.future);
          final bytes = await buildReceiptPdf(
            tx: detail.data,
            store: settings,
          );
          await Printing.sharePdf(
              bytes: bytes, filename: 'struk-$txId.pdf');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal berbagi struk: $e')),
      );
    }
  }

  void _showSuccess(String txId, int change) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Pembayaran Berhasil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                size: 56, color: Colors.green),
            const SizedBox(height: 12),
            const Text('Kembalian'),
            Text(
              formatRp(change),
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _shareReceipt(txId),
            child: const Text('Bagikan'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/riwayat/$txId');
            },
            child: const Text('Detail'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Transaksi Baru'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = ref.watch(cartTotalsProvider);
    final method = ref.watch(paymentMethodProvider);
    final payment = ref.watch(paymentInputProvider);
    final preview = ref.watch(checkoutPreviewProvider);
    final isCash = method == 'tunai';

    // Non-tunai selalu uang pas.
    ref.listen(cartTotalsProvider, (_, next) {
      if (ref.read(paymentMethodProvider) != 'tunai') {
        ref.read(paymentInputProvider.notifier).state = next.total;
      }
    });

    final effectivePayment = isCash ? payment : totals.total;
    final change = effectivePayment - totals.total;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pembayaran',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(formatRp(totals.total),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'tunai', label: Text('Tunai')),
                ButtonSegment(value: 'qris', label: Text('QRIS')),
                ButtonSegment(value: 'transfer', label: Text('Transfer')),
              ],
              selected: {method},
              onSelectionChanged: (s) {
                ref.read(paymentMethodProvider.notifier).state = s.single;
                if (s.single != 'tunai') {
                  ref.read(paymentInputProvider.notifier).state =
                      totals.total;
                  _payment.text = totals.total.toString();
                } else {
                  _setPayment(0);
                }
              },
            ),
            if (isCash) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Uang pas'),
                    onPressed: () => _setPayment(totals.total),
                  ),
                  for (final a in _quickAmounts)
                    ActionChip(
                      label: Text('${a ~/ 1000}rb'),
                      onPressed: () => _setPayment(
                          ref.read(paymentInputProvider) + a),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _payment,
                decoration: const InputDecoration(
                    labelText: 'Nominal bayar (Rp)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => ref
                    .read(paymentInputProvider.notifier)
                    .state = parseRp(v),
              ),
            ],
            const SizedBox(height: 12),
            preview.when(
              data: (_) => Text(
                'Kembalian: ${formatRp(change)}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text(
                e.toString(),
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy ? null : () => _pay(ref),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isCash ? 'Bayar' : 'Bayar ${formatRp(totals.total)}'),
            ),
          ],
        ),
      ),
    );
  }
}
