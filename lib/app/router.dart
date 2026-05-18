import 'dart:ui';
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
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Application router with ShellRoute for bottom navigation.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
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
      extendBody: true,
      drawer: const AppDrawer(),
      body: child,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.pearl.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glassShadow.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (i) {
                    final isSelected = (currentIndex < 0 ? 0 : currentIndex) == i;
                    final activeColor = AppColors.goldDark;
                    final inactiveColor = AppColors.mediumGrey;

                    Widget iconWidget;
                    String label;
                    if (i == 0) {
                      iconWidget = Icon(
                        isSelected ? Iconsax.home_2 : Iconsax.home_2_copy,
                        color: isSelected ? activeColor : inactiveColor,
                        size: 24,
                      );
                      label = 'Inicio';
                    } else if (i == 1) {
                      iconWidget = Icon(
                        isSelected ? Iconsax.shop : Iconsax.shop_copy,
                        color: isSelected ? activeColor : inactiveColor,
                        size: 24,
                      );
                      label = 'Tienda';
                    } else if (i == 2) {
                      iconWidget = Badge(
                        isLabelVisible: cartCount > 0,
                        label: Text(
                          '$cartCount',
                          style: AppTypography.badge.copyWith(
                            color: AppColors.white,
                            fontSize: 9,
                          ),
                        ),
                        backgroundColor: AppColors.gold,
                        child: Icon(
                          isSelected ? Iconsax.bag_2 : Iconsax.bag_2_copy,
                          color: isSelected ? activeColor : inactiveColor,
                          size: 24,
                        ),
                      );
                      label = 'Carrito';
                    } else {
                      iconWidget = Icon(
                        isSelected ? Iconsax.user : Iconsax.user_copy,
                        color: isSelected ? activeColor : inactiveColor,
                        size: 24,
                      );
                      label = 'Perfil';
                    }

                    return Expanded(
                      child: InkWell(
                        onTap: () => context.go(_tabs[i]),
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconWidget,
                            const SizedBox(height: 4),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: isSelected ? activeColor : inactiveColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
