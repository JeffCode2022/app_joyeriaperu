import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

/// Premium automatic sliding banner carousel with Liquid-Glass design.
class AutoCarouselBanner extends StatefulWidget {
  const AutoCarouselBanner({super.key});

  @override
  State<AutoCarouselBanner> createState() => _AutoCarouselBannerState();
}

class _AutoCarouselBannerState extends State<AutoCarouselBanner> {
  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 0;

  final List<_BannerItem> _banners = [
    const _BannerItem(
      title: 'Colección\nPrimavera 2026',
      subtitle: 'Hasta 30% OFF',
      baseColor: Color(0xFF1E1A0F),
      liquidColors: [AppColors.goldLight, AppColors.gold, Color(0xFF8C6D05)],
      icon: Iconsax.diamonds,
    ),
    const _BannerItem(
      title: 'Elegancia en\nOro Rosa',
      subtitle: 'Brillo sutil y femenino',
      baseColor: Color(0xFF221618),
      liquidColors: [Color(0xFFF1D2D5), AppColors.roseGold, Color(0xFF6B3A41)],
      icon: Iconsax.crown,
    ),
    const _BannerItem(
      title: 'Piezas Únicas\nHechas a Mano',
      subtitle: 'Calidad artesanal 18K',
      baseColor: Color(0xFF121214),
      liquidColors: [Color(0xFFB5C1D0), AppColors.mediumGrey, Color(0xFF3A3D42)],
      icon: Iconsax.award,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 156,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: banner.baseColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glassShadow.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // 1. Shifting background liquid blobs
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: banner.liquidColors,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          left: 40,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: banner.liquidColors.reversed.toList(),
                              ),
                            ),
                          ),
                        ),
                        // 2. Frosted glassmorphism overlay
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.12),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        // 3. Card Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      banner.title,
                                      style: AppTypography.headlineLarge.copyWith(
                                        color: AppColors.white,
                                        height: 1.2,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        shadows: [
                                          const Shadow(
                                            color: Colors.black38,
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // High-end glassmorphic gold badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [AppColors.goldLight, AppColors.gold],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.gold.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        banner.subtitle,
                                        style: AppTypography.labelMedium.copyWith(
                                          color: AppColors.charcoal,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Floating luxurious icon with soft glass backdrop
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Icon(
                                  banner.icon,
                                  size: 32,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Luxury page indicators
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: i == _currentPage ? 18 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerItem {
  final String title;
  final String subtitle;
  final Color baseColor;
  final List<Color> liquidColors;
  final IconData icon;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.baseColor,
    required this.liquidColors,
    required this.icon,
  });
}
