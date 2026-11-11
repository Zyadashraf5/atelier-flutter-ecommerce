import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/widgets/atelier_bottom_nav.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/cart/widgets/cart_body.dart';
import 'package:mine_ecommerce/features/cart/widgets/cart_empty_state.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const SizedBox(width: 56),
            title: Text(
              'Atelier',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: AppColors.navy,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.navy,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: c.lines.isEmpty
              ? const CartEmptyState()
              : CartBody(lines: c.lines, controller: c),
          bottomNavigationBar: const AtelierBottomNav(
            current: AtelierNavTab.cart,
          ),
        );
      },
    );
  }
}
