import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/core/widgets/atelier_bottom_nav.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/profile/controller/profile_controller.dart';
import 'package:mine_ecommerce/features/profile/widgets/profile_header_card.dart';
import 'package:mine_ecommerce/features/profile/widgets/profile_menu_tile.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = AppResponsive.horizontalPadding(context);
    return GetBuilder<ProfileController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'Atelier',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: AppColors.navy,
              ),
            ),
            actions: [
              GetBuilder<CartController>(
                builder: (cart) => Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.navy,
                      ),
                      onPressed: () => Get.offNamed(AppRoutes.cart),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.navy,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(pad, 8, pad, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your atelier account',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ProfileHeaderCard(
                      avatarUrl: c.avatarDisplayUrl,
                      name: c.displayName.isEmpty ? 'Member' : c.displayName,
                      email: c.email.isEmpty ? '—' : c.email,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'ACCOUNT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'My orders',
                      onTap: () => c.onMenuTap('My orders'),
                    ),
                    const SizedBox(height: 10),
                    ProfileMenuTile(
                      icon: Icons.favorite_outline_rounded,
                      title: 'Saved pieces',
                      onTap: () => c.onMenuTap('Saved pieces'),
                    ),
                    const SizedBox(height: 10),
                    ProfileMenuTile(
                      icon: Icons.location_on_outlined,
                      title: 'Addresses',
                      onTap: () => c.onMenuTap('Addresses'),
                    ),
                    const SizedBox(height: 10),
                    ProfileMenuTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Payment methods',
                      onTap: () => c.onMenuTap('Payment methods'),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'SUPPORT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuTile(
                      icon: Icons.headset_mic_outlined,
                      title: 'Help & support',
                      onTap: () => c.onMenuTap('Help'),
                    ),
                    const SizedBox(height: 10),
                    ProfileMenuTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () => c.onMenuTap('Settings'),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: TextButton(
                        onPressed: c.signOut,
                        child: Text(
                          'Sign out',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Atelier v1.0 · Curated lifestyle',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const AtelierBottomNav(
            current: AtelierNavTab.profile,
          ),
        );
      },
    );
  }
}
