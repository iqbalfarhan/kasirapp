import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/theme.dart';
import 'package:kasirapp/router.dart';

/// Root aplikasi: MaterialApp.router + tema tunggal kasir.
class KasirappApp extends ConsumerWidget {
  const KasirappApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Kasirapp POS',
      theme: buildAppTheme(),
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
