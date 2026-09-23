import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kasirapp/core/money.dart';
import 'package:kasirapp/core/period.dart';
import 'package:kasirapp/features/transactions/presentation/providers/history_providers.dart';

/// Riwayat: filter cepat + custom range + search + badge batal.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(historyListProvider);
    final range = ref.watch(historyRangeProvider);
    final dateFmt = DateFormat('dd MMM HH:mm', 'id_ID');

    Future<void> pickCustom() async {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        ref.read(historyCustomProvider.notifier).state = DateRange(
          start: picked.start,
          end: picked.end,
        );
        ref.read(historyRangeProvider.notifier).state =
            HistoryRange.custom;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final r in HistoryRange.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(switch (r) {
                        HistoryRange.today => 'Hari ini',
                        HistoryRange.last7 => '7 hari',
                        HistoryRange.last30 => '30 hari',
                        HistoryRange.custom => 'Custom',
                      }),
                      selected: range == r,
                      onSelected: (_) {
                        if (r == HistoryRange.custom) {
                          pickCustom();
                        } else {
                          ref
                              .read(historyRangeProvider.notifier)
                              .state = r;
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari ID / pelanggan...',
              ),
              onChanged: (v) =>
                  ref.read(historyQueryProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: list.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada transaksi.'));
                }
                final total = items
                    .where((e) => !e.isVoided)
                    .fold<int>(0, (s, e) => s + e.total);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${items.length} transaksi'),
                          Text(formatRp(total),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final tx = items[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: tx.isVoided
                                  ? Colors.grey.shade300
                                  : null,
                              child: Icon(
                                tx.paymentMethod == 'tunai'
                                    ? Icons.payments
                                    : Icons.qr_code,
                              ),
                            ),
                            title: Text(
                              '#${tx.id.substring(0, 8)} • ${formatRp(tx.total)}',
                              style: TextStyle(
                                decoration: tx.isVoided
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              '${dateFmt.format(tx.createdAt)} • '
                              '${tx.items.length} item • '
                              '${tx.paymentMethod.toUpperCase()}',
                            ),
                            trailing: tx.isVoided
                                ? const Chip(
                                    label: Text('BATAL'),
                                    visualDensity:
                                        VisualDensity.compact,
                                  )
                                : const Icon(Icons.chevron_right),
                            onTap: () =>
                                context.go('/riwayat/${tx.id}'),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gagal memuat: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
