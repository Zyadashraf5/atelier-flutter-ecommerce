import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = AppResponsive.horizontalPadding(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(pad + 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your cart is empty',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.offNamed(AppRoutes.home),
              child: Text(
                'Browse collection',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
