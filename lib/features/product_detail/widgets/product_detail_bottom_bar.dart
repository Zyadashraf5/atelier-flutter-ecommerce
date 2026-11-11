import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/features/product_detail/controller/product_detail_controller.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class ProductDetailBottomBar extends StatelessWidget {
  const ProductDetailBottomBar({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home_outlined, color: AppColors.textMuted),
              onPressed: controller.goHome,
            ),
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textMuted),
              onPressed: controller.goSearch,
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.navyAlt,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: controller.goCart,
                child: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.textMuted,
              ),
              onPressed: () => Get.offNamed(AppRoutes.profile),
            ),
          ],
        ),
      ),
    );
  }
}
