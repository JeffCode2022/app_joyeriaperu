
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';


import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../domain/entities/product.dart';

/// Premium product card with promo price, favorite toggle, and shimmer loading.
class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(product.id));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.softGrey.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.glassShadow.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Area ──
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      product.images.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.lightGrey,
                        child: const Icon(
                          Iconsax.image,
                          color: AppColors.mediumGrey,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  // Badges
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        if (product.hasPromo)
                          _Badge(
                            label: '-${product.discountPercent.toInt()}%',
                            color: AppColors.error,
                          ),
                        if (product.isNew) ...[
                          const SizedBox(width: 4),
                          _Badge(
                            label: 'Nuevo',
                            color: AppColors.gold,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(product.id);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.glassShadow,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav ? Iconsax.heart_copy : Iconsax.heart,
                          size: 16,
                          color: isFav ? AppColors.error : AppColors.charcoal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info Area ──
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.material + (product.karats != null ? ' ${product.karats}' : ''),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                      maxLines: 1,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (product.hasPromo)
                                Text(
                                  'S/ ${product.price.toStringAsFixed(0)}',
                                  style: AppTypography.priceOld.copyWith(
                                    color: AppColors.mediumGrey,
                                    fontSize: 11,
                                  ),
                                ),
                              Text(
                                'S/ ${(product.promoPrice ?? product.price).toStringAsFixed(0)}',
                                style: AppTypography.price.copyWith(
                                  color: AppColors.gold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add to cart mini button
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.charcoal,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Iconsax.bag_2,
                              color: AppColors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.badge.copyWith(color: AppColors.white),
      ),
    );
  }
}
