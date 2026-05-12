import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_search_bar.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_modal.dart';

/// Shop screen — Full catalog with category filters.
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(allProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final displayProducts = searchQuery.isNotEmpty
        ? searchResults
        : selectedCategory != null
            ? ref.watch(productsByCategoryProvider(selectedCategory))
            : allProducts;

    return Scaffold(
      backgroundColor: AppColors.pearl,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 100,
            backgroundColor: AppColors.pearl,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tienda',
                            style: AppTypography.displayMedium,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.filter),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const GlassSearchBar(
                      backgroundColor: Color(0xFFF2F2F7),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            toolbarHeight: 0,
          ),

          // ── Category Filter Row ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return FilterChip(
                      label: const Text('Todos'),
                      selected: selectedCategory == null,
                      onSelected: (_) => ref
                          .read(selectedCategoryProvider.notifier)
                          .state = null,
                    );
                  }
                  final cat = categories[i - 1];
                  return FilterChip(
                    label: Text('${cat.icon} ${cat.name}'),
                    selected: selectedCategory == cat.id,
                    onSelected: (_) => ref
                        .read(selectedCategoryProvider.notifier)
                        .state = selectedCategory == cat.id ? null : cat.id,
                  );
                },
              ),
            ),
          ),

          // ── Results Count ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${displayProducts.length} productos',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.mediumGrey),
              ),
            ),
          ),

          // ── Grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childCount: displayProducts.length,
              itemBuilder: (context, index) {
                final product = displayProducts[index];
                return SizedBox(
                  height: index.isEven ? 260 : 240,
                  child: ProductCard(
                    product: product,
                    onTap: () => _showDetail(context, product),
                    onAddToCart: () {
                      ref.read(cartProvider.notifier).addItem(
                            productId: product.id,
                            productName: product.name,
                            productImage: product.images.first,
                            unitPrice: product.promoPrice ?? product.price,
                          );
                    },
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailModal(product: product),
    );
  }
}
