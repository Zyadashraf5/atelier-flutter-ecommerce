import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

class CheckoutSummaryRow extends StatelessWidget {
  const CheckoutSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.muted = false,
    this.valueIsAccent = false,
  });

  final String label;
  final String value;
  final bool muted;
  final bool valueIsAccent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontWeight: muted ? FontWeight.w400 : FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: valueIsAccent
                  ? AppColors.fabBlue
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
