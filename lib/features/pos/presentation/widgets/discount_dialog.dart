import 'package:flutter/material.dart';
import 'package:kasirapp/features/pos/domain/entities/discount.dart';

/// Dialog diskon % / Rp. Mengembalikan null bila dibatalkan.
Future<Discount?> showDiscountDialog(
  BuildContext context, {
  required String title,
  Discount current = const Discount(),
  int maxPercent = 20,
}) {
  var type = current.type;
  final value = TextEditingController(
      text: current.isNone ? '' : current.value.toString());

  return showDialog<Discount>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<DiscountType>(
              segments: const [
                ButtonSegment(
                    value: DiscountType.none, label: Text('Tanpa')),
                ButtonSegment(
                    value: DiscountType.percent, label: Text('%')),
                ButtonSegment(
                    value: DiscountType.amount, label: Text('Rp')),
              ],
              selected: {type},
              onSelectionChanged: (s) => setState(() => type = s.single),
            ),
            if (type != DiscountType.none) ...[
              const SizedBox(height: 12),
              TextField(
                controller: value,
                decoration: InputDecoration(
                  labelText:
                      type == DiscountType.percent ? 'Persen (0-100)' : 'Rupiah',
                  helperText: type == DiscountType.percent && maxPercent > 0
                      ? 'Maks $maxPercent%'
                      : null,
                ),
                keyboardType: TextInputType.number,
                autofocus: true,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (type == DiscountType.none) {
                Navigator.pop(ctx, const Discount());
                return;
              }
              final v = int.tryParse(value.text.trim());
              if (v == null || v <= 0) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Nilai diskon tidak valid')),
                );
                return;
              }
              if (type == DiscountType.percent) {
                if (v > 100) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                        content: Text('Persen maksimal 100')),
                  );
                  return;
                }
                if (maxPercent > 0 && v > maxPercent) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                        content:
                            Text('Melebihi batas $maxPercent%')),
                  );
                  return;
                }
              }
              Navigator.pop(
                  ctx, Discount(type: type, value: v));
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    ),
  );
}
