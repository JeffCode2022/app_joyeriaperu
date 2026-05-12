import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:luxe_joyas/features/products/presentation/providers/product_providers.dart';
import 'package:luxe_joyas/app/theme/app_colors.dart';

/// Persistent glass-morphism search bar that adapts color per screen.
class GlassSearchBar extends ConsumerWidget {
  final Color? backgroundColor;
  final String hintText;

  const GlassSearchBar({
    super.key,
    this.backgroundColor,
    this.hintText = 'Buscar joyas, anillos, collares...',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: TextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            style: TextStyle(
              fontSize: 14,
              color: AppColors.charcoal,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.mediumGrey,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Iconsax.search_normal_1,
                color: AppColors.mediumGrey,
                size: 20,
              ),
              border: InputBorder.none,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
