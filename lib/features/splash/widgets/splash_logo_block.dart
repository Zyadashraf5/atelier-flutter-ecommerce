import 'package:flutter/material.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

class SplashLogoBlock extends StatelessWidget {
  const SplashLogoBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 44,
            color: AppColors.navy,
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: AppColors.brownBadge,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
