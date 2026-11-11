import 'package:flutter/material.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

class OrderConfirmationHero extends StatelessWidget {
  const OrderConfirmationHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.lightBlueSoft,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: -8,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.navy,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration_outlined,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
