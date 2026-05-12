
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../providers/cart_providers.dart';

/// Functional shopping cart screen with persistent items.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);

    return Scaffold(
      backgroundColor: AppColors.pearl,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.pearl,
            title: Text('Mi Carrito', style: AppTypography.displaySmall),
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: () => _showClearDialog(context, ref),
                  child: Text(
                    'Vaciar',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.error),
                  ),
                ),
            ],
          ),

          if (items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.bag,
                      size: 64,
                      color: AppColors.softGrey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tu carrito está vacío',
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explora nuestra colección y agrega\npiezas que te encanten',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),
            )
          else ...[
            // ── Cart Items ──
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) =>
                        ref.read(cartProvider.notifier).removeItem(item.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Iconsax.trash,
                        color: AppColors.error,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.softGrey.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item.productImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: AppColors.lightGrey,
                                child: const Icon(Iconsax.image, color: AppColors.mediumGrey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: AppTypography.labelLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.selectedOptions.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      item.selectedOptions.values.join(' · '),
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.mediumGrey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'S/ ${item.totalPrice.toStringAsFixed(0)}',
                                      style: AppTypography.price.copyWith(
                                        color: AppColors.gold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    // Quantity controls
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.softGrey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _QtyBtn(
                                            icon: Iconsax.minus,
                                            onTap: () => ref
                                                .read(
                                                    cartProvider.notifier)
                                                .updateQuantity(
                                                  item.id,
                                                  item.quantity - 1,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            child: Text(
                                              '${item.quantity}',
                                              style: AppTypography
                                                  .labelLarge,
                                            ),
                                          ),
                                          _QtyBtn(
                                            icon: Iconsax.add,
                                            onTap: () => ref
                                                .read(
                                                    cartProvider.notifier)
                                                .updateQuantity(
                                                  item.id,
                                                  item.quantity + 1,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(
                          delay: (index * 80).ms,
                          duration: 300.ms,
                        ),
                  );
                },
              ),
            ),

            // ── Summary ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.softGrey.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Subtotal',
                        value: 'S/ ${subtotal.toStringAsFixed(0)}',
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Envío',
                        value: 'Gratis',
                        valueColor: AppColors.success,
                      ),
                      const Divider(height: 20),
                      _SummaryRow(
                        label: 'Total',
                        value: 'S/ ${subtotal.toStringAsFixed(0)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
      // ── Checkout Button ──
      bottomNavigationBar: items.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.glassShadow.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Inicia sesión para completar tu compra'),
                      backgroundColor: AppColors.gold,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Ir al checkout — S/ ${subtotal.toStringAsFixed(0)}',
                ),
              ),
            )
          : null,
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Vaciar carrito?'),
        content: const Text(
          'Se eliminarán todos los productos de tu carrito.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
            },
            child: Text(
              'Vaciar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: AppColors.charcoal),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.headlineSmall
              : AppTypography.bodyMedium
                  .copyWith(color: AppColors.mediumGrey),
        ),
        Text(
          value,
          style: isBold
              ? AppTypography.price.copyWith(color: AppColors.gold)
              : AppTypography.labelLarge
                  .copyWith(color: valueColor ?? AppColors.charcoal),
        ),
      ],
    );
  }
}
