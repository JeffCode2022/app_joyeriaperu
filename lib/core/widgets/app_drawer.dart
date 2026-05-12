import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:luxe_joyas/app/theme/app_colors.dart';
import 'package:luxe_joyas/app/theme/app_typography.dart';

/// Luxury drawer with quick access options.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.pearl,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Iconsax.diamonds,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Joyería Perú', style: AppTypography.displaySmall),
                  const SizedBox(height: 4),
                  Text(
                    'Joyería Premium',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.mediumGrey),
                  ),
                ],
              ),
            ),
            const Divider(),
            _DrawerItem(
              icon: Iconsax.home_2,
              label: 'Inicio',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Iconsax.category_2,
              label: 'Categorías',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Iconsax.heart,
              label: 'Favoritos',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Iconsax.shopping_bag,
              label: 'Mis Pedidos',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Iconsax.discount_shape,
              label: 'Ofertas',
              badge: 'Nuevo',
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            _DrawerItem(
              icon: Iconsax.setting_2,
              label: 'Configuración',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Iconsax.info_circle,
              label: 'Acerca de',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Iconsax.message_question,
              label: 'Soporte',
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'v1.0.0 — Con ♥ para ti',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.mediumGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: AppColors.charcoal),
      title: Text(label, style: AppTypography.bodyMedium),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.white,
                ),
              ),
            )
          : null,
      onTap: onTap,
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
