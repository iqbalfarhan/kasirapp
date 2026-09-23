import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kasirapp/app_shell.dart';
import 'package:kasirapp/features/customers/presentation/screens/customers_screen.dart';
import 'package:kasirapp/features/pos/presentation/screens/pos_screen.dart';
import 'package:kasirapp/features/products/presentation/screens/products_screen.dart';
import 'package:kasirapp/features/reports/presentation/screens/report_screen.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';
import 'package:kasirapp/features/settings/presentation/screens/backup_page.dart';
import 'package:kasirapp/features/settings/presentation/screens/change_pin_screen.dart';
import 'package:kasirapp/features/settings/presentation/screens/login_screen.dart';
import 'package:kasirapp/features/settings/presentation/screens/setting_sub_pages.dart';
import 'package:kasirapp/features/settings/presentation/screens/settings_screen.dart';
import 'package:kasirapp/features/settings/presentation/screens/users_page.dart';
import 'package:kasirapp/features/transactions/presentation/screens/history_detail_screen.dart';
import 'package:kasirapp/features/transactions/presentation/screens/history_screen.dart';

/// Sitemap: 3 tab — Kasir, Riwayat, Setting (+ stack hub).
/// Guard: belum login → /login; mustChangePin → /change-pin;
/// kasir ❌ /setting/users, /setting/tax.
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  String? guard(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    if (auth == null) {
      return loc == '/login' ? null : '/login';
    }
    if (auth.mustChangePin) {
      return loc == '/change-pin' ? null : '/change-pin';
    }
    if (loc == '/login' || loc == '/change-pin') return '/kasir';
    if (!auth.isAdmin &&
        (loc == '/setting/users' || loc == '/setting/tax')) {
      return '/setting';
    }
    return null;
  }

  return GoRouter(
    initialLocation: '/kasir',
    redirect: guard,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/change-pin',
        builder: (context, state) => const ChangePinScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/kasir',
                builder: (context, state) => const PosScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/riwayat',
                builder: (context, state) => const HistoryScreen(),
                routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => HistoryDetailScreen(
                      id: state.pathParameters['id'] ?? ''),
                ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/setting',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'products',
                    builder: (context, state) => const SubPageScaffold(
                      title: 'Menu',
                      child: ProductsScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'customers',
                    builder: (context, state) => const SubPageScaffold(
                      title: 'Pelanggan',
                      child: CustomersScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'reports',
                    builder: (context, state) => const SubPageScaffold(
                      title: 'Laporan',
                      child: ReportScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'store',
                    builder: (context, state) => const SubPageScaffold(
                      title: 'Info Toko',
                      child: StorePage(),
                    ),
                  ),
                  GoRoute(
                    path: 'tax',
                    builder: (context, state) => const SubPageScaffold(
                      title: 'Pajak & Diskon',
                      child: TaxPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'users',
                    builder: (context, state) => const SubPageScaffold(
                      title: 'Pengguna',
                      child: UsersPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'backup',
                    builder: (context, state) => const SubPageScaffold(
                      title: 'Backup',
                      child: BackupPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
