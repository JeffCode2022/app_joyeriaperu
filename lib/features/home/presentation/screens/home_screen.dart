import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:luxe_joyas/app/theme/app_colors.dart';
import 'package:luxe_joyas/app/theme/app_typography.dart';
import 'package:luxe_joyas/core/widgets/glass_search_bar.dart';
import 'package:luxe_joyas/features/cart/presentation/providers/cart_providers.dart';
import 'package:luxe_joyas/features/products/domain/entities/product.dart';
import 'package:luxe_joyas/features/products/presentation/providers/product_providers.dart';
import 'package:luxe_joyas/features/products/presentation/widgets/product_card.dart';
import 'package:luxe_joyas/features/products/presentation/widgets/product_detail_modal.dart';
import '../widgets/auto_carousel_banner.dart';

/// Home screen with categories, featured products, and promos.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final featured = ref.watch(featuredProductsProvider);
    final newProducts = ref.watch(newProductsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.pearl,
      body: CustomScrollView(
        slivers: [
          // ── App Bar with Glass Search ──
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 120,
            backgroundColor: AppColors.pearl,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '💍 Joyería Perú',
                                style: AppTypography.displayMedium,
                              ),
                              Text(
                                'Descubre piezas únicas',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.champagne,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Iconsax.notification,
                            color: AppColors.charcoal,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const GlassSearchBar(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            toolbarHeight: 0,
          ),

          // ── Categories ──
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                  child: Text('Categorías',
                      style: AppTypography.headlineMedium),
                ),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        final isAll = selectedCategory == null;
                        return _CategoryChip(
                          label: 'Todos',
                          emoji: '💎',
                          isSelected: isAll,
                          onTap: () => ref
                              .read(selectedCategoryProvider.notifier)
                              .state = null,
                        );
                      }
                      final cat = categories[i - 1];
                      final isSelected = selectedCategory == cat.id;
                      return _CategoryChip(
                        label: cat.name,
                        emoji: cat.icon,
                        count: cat.productCount,
                        isSelected: isSelected,
                        onTap: () => ref
                            .read(selectedCategoryProvider.notifier)
                            .state = isSelected ? null : cat.id,
                      );
                    },
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ],
            ),
          ),

          // ── Featured Banner Carousel ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 8),
              child: AutoCarouselBanner(),
            ),
          ),

          // ── Section Header ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedCategory != null
                          ? categories
                              .firstWhere((c) => c.id == selectedCategory)
                              .name
                          : 'Destacados',
                      style: AppTypography.headlineMedium,
                    ),
                  ),
                  Text(
                    'Ver todo',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Products Grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _buildProductGrid(context, ref, selectedCategory, featured),
          ),

          // ── New Arrivals ──
          if (selectedCategory == null && newProducts.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Text('Recién Llegados',
                    style: AppTypography.headlineMedium),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: _buildProductGrid(context, ref, null, newProducts),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
      BuildContext context, WidgetRef ref, String? categoryFilter, List<Product> products) {
    final items = categoryFilter != null
        ? ref.watch(productsByCategoryProvider(categoryFilter))
        : products;

    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childCount: items.length,
      itemBuilder: (ctx, index) {
        final product = items[index];
        return SizedBox(
          height: index.isEven ? 260 : 240,
          child: ProductCard(
            product: product,
            onTap: () => _showProductDetail(context, product),
            onAddToCart: () {
              ref.read(cartProvider.notifier).addItem(
                    productId: product.id,
                    productName: product.name,
                    productImage: product.images.first,
                    unitPrice: product.promoPrice ?? product.price,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} agregado'),
                  backgroundColor: AppColors.gold,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showProductDetail(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailModal(product: product),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.emoji,
    this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.charcoal : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.charcoal,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(
                '$count',
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.goldLight
                      : AppColors.mediumGrey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
