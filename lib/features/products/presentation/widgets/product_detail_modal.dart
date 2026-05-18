import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';


import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';

/// iOS 26 / Honor liquid-glass style product detail modal.
class ProductDetailModal extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailModal({super.key, required this.product});

  @override
  ConsumerState<ProductDetailModal> createState() =>
      _ProductDetailModalState();
}

class _ProductDetailModalState extends ConsumerState<ProductDetailModal> {
  late Product _activeProduct;
  late Map<String, String> _selectedOptions;
  int _currentImageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _activeProduct = widget.product;
    _initProduct(_activeProduct);
  }

  void _initProduct(Product product) {
    _selectedOptions = {
      for (final opt in product.options) opt.label: opt.values.first,
    };
    _currentImageIndex = 0;
    _quantity = 1;
  }

  @override
  void didUpdateWidget(ProductDetailModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      setState(() {
        _activeProduct = widget.product;
        _initProduct(_activeProduct);
      });
    }
  }

  double get _calculatedPrice {
    double price = _activeProduct.promoPrice ?? _activeProduct.price;
    for (final opt in _activeProduct.options) {
      if (opt.priceModifiers != null) {
        final selected = _selectedOptions[opt.label];
        if (selected != null && opt.priceModifiers!.containsKey(selected)) {
          price += opt.priceModifiers![selected]!;
        }
      }
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    final product = _activeProduct;
    final isFav = ref.watch(isFavoriteProvider(product.id));
    final recommendations = ref.watch(recommendationsProvider(product.id));

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.92,
          decoration: BoxDecoration(
            color: AppColors.pearl.withValues(alpha: 0.75),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
        children: [
          // ── Drag Handle ──
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Content ──
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Image Carousel ──
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 340,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: product.images.length,
                          onPageChanged: (i) =>
                              setState(() => _currentImageIndex = i),
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                product.images[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.lightGrey,
                                  child: const Icon(Iconsax.image, color: AppColors.mediumGrey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Page indicators
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (i) => AnimatedContainer(
                                duration: 300.ms,
                                width: i == _currentImageIndex ? 20 : 6,
                                height: 6,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: i == _currentImageIndex
                                      ? AppColors.gold
                                      : AppColors.softGrey,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Favorite & Share
                        Positioned(
                          top: 12,
                          right: 28,
                          child: Row(
                            children: [
                              _GlassButton(
                                icon:
                                    isFav ? Iconsax.heart_copy : Iconsax.heart,
                                iconColor: isFav
                                    ? AppColors.error
                                    : AppColors.charcoal,
                                onTap: () => ref
                                    .read(favoritesProvider.notifier)
                                    .toggleFavorite(product.id),
                              ),
                              const SizedBox(width: 8),
                              _GlassButton(
                                icon: Iconsax.share,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Product Info ──
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Name & Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: AppTypography.displaySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product.material}${product.karats != null ? " ${product.karats}" : ""}',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.champagne,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Iconsax.star,
                                    size: 14, color: AppColors.gold),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.rating}',
                                  style: AppTypography.labelMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  ' (${product.reviewCount})',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Row(
                        children: [
                          Text(
                            'S/ ${_calculatedPrice.toStringAsFixed(0)}',
                            style: AppTypography.price.copyWith(
                              color: AppColors.gold,
                              fontSize: 26,
                            ),
                          ),
                          if (product.hasPromo) ...[
                            const SizedBox(width: 10),
                            Text(
                              'S/ ${product.price.toStringAsFixed(0)}',
                              style: AppTypography.priceOld.copyWith(
                                color: AppColors.mediumGrey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${product.discountPercent.toInt()}%',
                                style: AppTypography.badge.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text('Descripción',
                          style: AppTypography.headlineSmall),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkGrey,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Customization Options ──
                      if (product.options.isNotEmpty) ...[
                        Text('Personalización',
                            style: AppTypography.headlineSmall),
                        const SizedBox(height: 12),
                        ...product.options.map(
                          (opt) => _OptionSelector(
                            option: opt,
                            selected: _selectedOptions[opt.label] ?? '',
                            onSelected: (value) {
                              setState(() {
                                _selectedOptions[opt.label] = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: product.tags
                            .map((tag) => Chip(
                                  label: Text('#$tag'),
                                  visualDensity: VisualDensity.compact,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 24),

                      // ── Recommendations ──
                      if (recommendations.isNotEmpty) ...[
                        Text('También te puede gustar',
                            style: AppTypography.headlineSmall),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendations.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final rec = recommendations[i];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeProduct = rec;
                                    _initProduct(rec);
                                  });
                                  try {
                                    final scrollController = PrimaryScrollController.of(context);
                                    if (scrollController.hasClients) {
                                      scrollController.animateTo(
                                        0,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  } catch (_) {}
                                },
                                child: SizedBox(
                                  width: 110,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        child: Image.asset(
                                          rec.images.first,
                                          width: 110,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        rec.name,
                                        style: AppTypography.labelSmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'S/ ${(rec.promoPrice ?? rec.price).toStringAsFixed(0)}',
                                        style:
                                            AppTypography.labelSmall.copyWith(
                                          color: AppColors.gold,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Bar: Quantity + Add to Cart ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.pearl.withValues(alpha: 0.6),
              border: const Border(
                top: BorderSide(
                  color: AppColors.glassBorder,
                  width: 1.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.glassShadow.withValues(alpha: 0.03),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Quantity
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.softGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _QtyButton(
                          icon: Iconsax.minus,
                          onTap: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '$_quantity',
                            style: AppTypography.headlineSmall,
                          ),
                        ),
                        _QtyButton(
                          icon: Iconsax.add,
                          onTap: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Add to Cart
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addItem(
                              productId: product.id,
                              productName: product.name,
                              productImage: product.images.first,
                              unitPrice: _calculatedPrice,
                              selectedOptions:
                                  Map<String, String>.from(_selectedOptions),
                              quantity: _quantity,
                            );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} agregado al carrito',
                            ),
                            backgroundColor: AppColors.gold,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Iconsax.bag_2, size: 20),
                      label: Text(
                        'Agregar — S/ ${(_calculatedPrice * _quantity).toStringAsFixed(0)}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),),);
  }
}

// ── Glass Button ──
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _GlassButton({
    required this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Icon(icon,
                size: 20, color: iconColor ?? AppColors.charcoal),
          ),
        ),
      ),
    );
  }
}

// ── Option Selector ──
class _OptionSelector extends StatelessWidget {
  final ProductOption option;
  final String selected;
  final ValueChanged<String> onSelected;

  const _OptionSelector({
    required this.option,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option.label,
            style: AppTypography.labelLarge
                .copyWith(color: AppColors.mediumGrey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: option.values.map((value) {
              final isSelected = value == selected;
              final modifier = option.priceModifiers?[value];
              return GestureDetector(
                onTap: () => onSelected(value),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.charcoal
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.softGrey),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.charcoal,
                        ),
                      ),
                      if (modifier != null && modifier != 0)
                        Text(
                          '${modifier > 0 ? "+" : ""}S/ ${modifier.toStringAsFixed(0)}',
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected
                                ? AppColors.goldLight
                                : AppColors.mediumGrey,
                            fontSize: 9,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Qty Button ──
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 18, color: AppColors.charcoal),
      ),
    );
  }
}
