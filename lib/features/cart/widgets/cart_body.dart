import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/data/models/cart_line.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/cart/widgets/cart_product_card.dart';
import 'package:mine_ecommerce/features/cart/widgets/cart_summary_card.dart';

class CartBody extends StatelessWidget {
  const CartBody({super.key, required this.lines, required this.controller});

  final List<CartLine> lines;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    final count = lines.fold(0, (a, b) => a + b.quantity);
    final pad = AppResponsive.horizontalPadding(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(pad, 8, pad, 24),
      children: [
        Text(
          'Cart.',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 32,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$count ITEMS SELECTED',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          lines.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CartProductCard(
              line: lines[i],
              onMinus: () => controller.setQuantity(i, lines[i].quantity - 1),
              onPlus: () => controller.setQuantity(i, lines[i].quantity + 1),
              onRemove: () => controller.removeAt(i),
            ),
          ),
        ),
        CartSummaryCard(controller: controller),
      ],
    );
  }
}
