import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

class LoginFieldLabel extends StatelessWidget {
  const LoginFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: AppColors.textMuted,
      ),
    );
  }
}
