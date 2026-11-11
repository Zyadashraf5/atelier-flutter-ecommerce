import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/checkout/controller/checkout_controller.dart';

class CheckoutFloatingPurchaseBar extends StatelessWidget {
  const CheckoutFloatingPurchaseBar({super.key});

  @override
  Widget build(BuildContext context) {
    final inset = AppResponsive.horizontalPadding(context);
    return Positioned(
      left: inset,
      right: inset,
      bottom: 18,
      child: SafeArea(
        top: false,
        child: GetBuilder<CheckoutController>(
          builder: (co) {
            return GetBuilder<CartController>(
              builder: (cart) {
                final total = cart.lines.isEmpty ? 0.0 : cart.total;
                final busy = co.submitting;
                final canTap = !busy && cart.lines.isNotEmpty;
                return Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(40),
                  color: canTap
                      ? AppColors.fabBlue
                      : AppColors.fabBlue.withValues(alpha: 0.5),
                  child: InkWell(
                    onTap: canTap ? co.completePurchaseFab : null,
                    borderRadius: BorderRadius.circular(40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 22,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              busy
                                  ? 'Processing...'
                                  : 'Place Order • \$${total.toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (busy)
                            const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
