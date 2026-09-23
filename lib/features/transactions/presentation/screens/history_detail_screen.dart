import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/receipt_pdf.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/customers/presentation/providers/customer_providers.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';
import 'package:kasirapp/features/transactions/domain/entities/transaction.dart';
import 'package:kasirapp/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:kasirapp/features/transactions/domain/usecases/void_transaction.dart';
import 'package:kasirapp/features/transactions/presentation/providers/history_providers.dart';
import 'package:printing/printing.dart';

/// Detail transaksi dari snapshot + void (admin) + cetak ulang struk.
class HistoryDetailScreen extends ConsumerWidget {
  const HistoryDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(historyDetailProvider(id));
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: detail.when(
        data: (tx) => _Body(tx: tx, isAdmin: isAdmin),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.tx, required this.isAdmin});

  final Transaction tx;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFmt = DateFormat('EEEE, dd MMM yyyy HH:mm', 'id_ID');
    final customers = ref.watch(customerListProvider);
    final users = ref.watch(usersProvider);

    String? customerName() {
      final cid = tx.customerId;
      if (cid == null) return null;
      for (final c in customers.valueOrNull ?? []) {
        if (c.id == cid) return c.name;
      }
      return null;
    }

    String cashierName() {
      for (final u in users.valueOrNull ?? []) {
        if (u.id == tx.cashierId) return u.name;
      }
      return tx.cashierId;
    }

    Future<void> doVoid() async {
      final reason = TextEditingController();
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Void Transaksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Stok barang akan dikembalikan. Alasan wajib diisi.'),
              const SizedBox(height: 8),
              TextField(
                controller: reason,
                decoration:
                    const InputDecoration(labelText: 'Alasan*'),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                  ctx, reason.text.trim().isNotEmpty),
              child: const Text('Void'),
            ),
          ],
        ),
      );
      if (ok != true || !context.mounted) return;
      final me = ref.read(authProvider);
      final repo = ref.read(transactionRepositoryProvider);
      final result = await VoidTransaction(repo, isAdmin: true)(
          VoidTransactionParams(
        id: tx.id,
        reason: reason.text.trim(),
        voidBy: me?.name ?? me?.id ?? 'admin',
      ));
      if (!context.mounted) return;
      switch (result) {
        case Success():
          ref.invalidate(historyListProvider);
          ref.invalidate(historyDetailProvider(tx.id));
          showOk(context, 'Transaksi dibatalkan');
        case FailureResult():
          showError(context, result.failure.message);
      }
    }

    Future<void> reprint() async {
      final settings = await ref.read(settingsProvider.future);
      if (!context.mounted) return;
      final bytes = await buildReceiptPdf(
        tx: tx,
        store: settings,
        cashierName: cashierName(),
        customerName: customerName(),
      );
      await Printing.layoutPdf(onLayout: (_) async => bytes);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (tx.isVoided)
          Card(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'BATAL${tx.voidReason == null ? '' : ' — ${tx.voidReason}'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        Text('#${tx.id}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(dateFmt.format(tx.createdAt)),
        Text(
            'Kasir: ${cashierName()} • ${tx.paymentMethod.toUpperCase()}'),
        if (customerName() != null) Text('Pelanggan: ${customerName()}'),
        const Divider(),
        for (final item in tx.items)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${item.nameSnapshot} x${item.qty}'),
            subtitle: Text(formatRp(item.unitPriceSnapshot)),
            trailing: Text(formatRp(item.subtotal)),
          ),
        const Divider(),
        _kv('Subtotal', formatRp(tx.subtotal)),
        if (tx.itemDiscountTotal > 0)
          _kv('Diskon item', '- ${formatRp(tx.itemDiscountTotal)}'),
        if (tx.receiptDiscountTotal > 0)
          _kv('Diskon struk',
              '- ${formatRp(tx.receiptDiscountTotal)}'),
        _kv('Pajak (${tx.taxPercent}%)', formatRp(tx.taxTotal)),
        _kv('TOTAL', formatRp(tx.total), bold: true),
        _kv('Bayar', formatRp(tx.payment)),
        _kv('Kembalian', formatRp(tx.change)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: reprint,
                icon: const Icon(Icons.print),
                label: const Text('Cetak Ulang'),
              ),
            ),
            if (isAdmin && !tx.isVoided) ...[
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white),
                  onPressed: doVoid,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Void'),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => context.go('/riwayat'),
          child: const Text('Kembali'),
        ),
      ],
    );
  }

  Widget _kv(String label, String value, {bool bold = false}) {
    final style = bold
        ? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
