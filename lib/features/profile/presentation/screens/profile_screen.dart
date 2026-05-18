import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

/// Profile screen with user info, order history, and settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pearl,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.pearl,
            title: Text('Mi Perfil', style: AppTypography.displaySmall),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Avatar ──
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.user,
                      size: 36,
                      color: AppColors.white,
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
                  const SizedBox(height: 14),
                  Text('Invitado', style: AppTypography.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Inicia sesión para acceder a tu cuenta',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.mediumGrey),
                  ),
                  const SizedBox(height: 20),

                  // ── Login Button ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/login'),
                      icon: const Icon(Iconsax.login, size: 20),
                      label: const Text('Iniciar Sesión'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/register'),
                      icon: const Icon(Iconsax.user_add, size: 20),
                      label: const Text('Crear Cuenta'),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ── Menu Sections ──
                  _Section(
                    title: 'Mi Cuenta',
                    items: [
                      _MenuItem(
                        icon: Iconsax.bag_2,
                        label: 'Mis Pedidos',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.heart,
                        label: 'Favoritos',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.location,
                        label: 'Direcciones',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.card,
                        label: 'Métodos de Pago',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: 'Soporte',
                    items: [
                      _MenuItem(
                        icon: Iconsax.message_question,
                        label: 'Centro de Ayuda',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.call,
                        label: 'Contáctanos',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.document_text,
                        label: 'Términos y Condiciones',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.shield_tick,
                        label: 'Política de Privacidad',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Joyería Perú v1.0.0',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.mediumGrey),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.headlineSmall),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.softGrey.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast) const Divider(height: 1, indent: 52),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: AppColors.charcoal),
      title: Text(label, style: AppTypography.bodyMedium),
      trailing: const Icon(
        Iconsax.arrow_right_3,
        size: 18,
        color: AppColors.mediumGrey,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
