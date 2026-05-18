import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

/// Premium glassmorphism register screen with Light Jewelry background.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Jewelry Background (Light & Crisp)
          Positioned.fill(
            child: Image.asset(
              'assets/images/pearls_set.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Translucent Light-Pearl Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.pearl.withValues(alpha: 0.8),
                    AppColors.pearl.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),

          // 3. Main Frosted Glass Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.glassShadow.withValues(alpha: 0.05),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Luxury Brand Header
                        const Center(
                          child: Icon(
                            Iconsax.user_add,
                            size: 48,
                            color: AppColors.goldDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Crear Cuenta',
                            style: AppTypography.headlineLarge.copyWith(
                              color: AppColors.charcoal,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Center(
                          child: Text(
                            'Únete a la experiencia de lujo',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.charcoal.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Full Name Input (Glass Light)
                        _buildGlassTextField(
                          controller: _nameController,
                          hintText: 'Nombre completo',
                          icon: Iconsax.user,
                        ),
                        const SizedBox(height: 16),

                        // Email Input (Glass Light)
                        _buildGlassTextField(
                          controller: _emailController,
                          hintText: 'Correo electrónico',
                          icon: Iconsax.sms,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // Password Input (Glass Light)
                        _buildGlassTextField(
                          controller: _passwordController,
                          hintText: 'Contraseña',
                          icon: Iconsax.lock,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Iconsax.eye : Iconsax.eye_slash,
                              color: AppColors.charcoal.withValues(alpha: 0.5),
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Input (Glass Light)
                        _buildGlassTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirmar contraseña',
                          icon: Iconsax.lock_1,
                          obscureText: _obscurePassword,
                        ),
                        const SizedBox(height: 28),

                        // Register CTA Button (Gold Liquid)
                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Registrarse',
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.charcoal,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Navigate back to Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes cuenta? ',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.charcoal.withValues(alpha: 0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Text(
                                'Inicia Sesión',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.goldDark,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.charcoal, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.charcoal.withValues(alpha: 0.5), fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.charcoal.withValues(alpha: 0.6), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }
}
