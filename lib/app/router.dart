import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/widgets/app_drawer.dart';
import '../features/cart/presentation/providers/cart_providers.dart';
import '../features/cart/presentation/screens/cart_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/products/presentation/screens/shop_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Application router with ShellRoute for bottom navigation.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (_, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/shop',
            pageBuilder: (_, state) => const NoTransitionPage(
              child: ShopScreen(),
            ),
          ),
          GoRoute(
            path: '/cart',
            pageBuilder: (_, state) => const NoTransitionPage(
              child: CartScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

/// Main shell with BottomNavigationBar and Drawer.
class _MainShell extends ConsumerWidget {
  final Widget child;
  const _MainShell({required this.child});

  static const _tabs = ['/home', '/shop', '/cart', '/profile'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t));
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      key: const ValueKey('main_shell'),
      drawer: const AppDrawer(),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: [
          const NavigationDestination(
            icon: Icon(Iconsax.home_2),
            selectedIcon: Icon(Iconsax.home_2_copy),
            label: 'Inicio',
          ),
          const NavigationDestination(
            icon: Icon(Iconsax.shop),
            selectedIcon: Icon(Iconsax.shop_copy),
            label: 'Tienda',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(
                '$cartCount',
                style: AppTypography.badge.copyWith(
                  color: AppColors.white,
                  fontSize: 9,
                ),
              ),
              backgroundColor: AppColors.gold,
              child: const Icon(Iconsax.bag_2),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(
                '$cartCount',
                style: AppTypography.badge.copyWith(
                  color: AppColors.white,
                  fontSize: 9,
                ),
              ),
              backgroundColor: AppColors.gold,
              child: const Icon(Iconsax.bag_2_copy),
            ),
            label: 'Carrito',
          ),
          const NavigationDestination(
            icon: Icon(Iconsax.user),
            selectedIcon: Icon(Iconsax.user_copy),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
