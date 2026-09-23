import 'package:flutter/material.dart';
import 'package:kasirapp/core/responsive.dart';

/// Placeholder layar POS. UI penuh (grid + cart split) dibangun di Fase 2.
/// Responsive: HP = kolom tunggal, tablet = 2 panel.
class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (isTablet(context)) {
      return const Row(
        children: [
          Expanded(flex: 3, child: _MenuGrid()),
          VerticalDivider(width: 1),
          Expanded(flex: 2, child: _CartPanel()),
        ],
      );
    }
    return const Column(
      children: [
        Expanded(child: _MenuGrid()),
        _CartSummaryBar(),
      ],
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Grid menu (Fase 1-2)'));
  }
}

class _CartPanel extends StatelessWidget {
  const _CartPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Keranjang (Fase 2)'));
  }
}

class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Ringkasan keranjang (Fase 2)'),
      ),
    );
  }
}
