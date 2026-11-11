import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/checkout/controller/checkout_controller.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_order_summary_card.dart';

class CheckoutOrderSummarySection extends StatelessWidget {
  const CheckoutOrderSummarySection({super.key, required this.checkout});

  final CheckoutController checkout;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cart) {
        if (cart.lines.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Your cart is empty. Add pieces from Home or Search before checkout.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          );
        }
        final lines = cart.lines
            .map(
              (l) => CheckoutLineUi(
                title: l.product.name,
                subtitle: l.variantLabel.isEmpty
                    ? (l.product.subtitle.isEmpty
                          ? 'Standard'
                          : l.product.subtitle)
                    : l.variantLabel,
                price: l.product.price * l.quantity,
                imageUrl: l.product.imageUrl,
              ),
            )
            .toList();
        return CheckoutOrderSummaryCard(
          lines: lines,
          subtotal: cart.subtotal,
          shippingLabel: 'Free',
          tax: cart.tax,
          total: cart.total,
        );
      },
    );
  }
}
