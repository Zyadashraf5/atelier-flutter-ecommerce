import 'package:flutter/material.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

class SplashPageIndicator extends StatelessWidget {
  const SplashPageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: AppColors.inputFill,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: const Color(0xFF4A6FA5),
            ),
          ),
        ),
      ),
    );
  }
}
