import 'package:flutter/material.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

class CheckoutPlainTextField extends StatelessWidget {
  const CheckoutPlainTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
