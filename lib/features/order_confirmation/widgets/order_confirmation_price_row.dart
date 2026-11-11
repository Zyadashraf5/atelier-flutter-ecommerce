import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

class OrderConfirmationPriceRow extends StatelessWidget {
  const OrderConfirmationPriceRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
