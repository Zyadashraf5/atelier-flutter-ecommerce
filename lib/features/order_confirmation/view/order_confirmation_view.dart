import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/features/order_confirmation/controller/order_confirmation_controller.dart';
import 'package:mine_ecommerce/features/order_confirmation/widgets/order_confirmation_delivery_section.dart';
import 'package:mine_ecommerce/features/order_confirmation/widgets/order_confirmation_hero.dart';
import 'package:mine_ecommerce/features/order_confirmation/widgets/order_confirmation_summary_card.dart';

class OrderConfirmationView extends GetView<OrderConfirmationController> {
  const OrderConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = AppResponsive.horizontalPadding(context);
    return GetBuilder<OrderConfirmationController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: pad, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const OrderConfirmationHero(),
                      const SizedBox(height: 28),
                      Text(
                        'Order Confirmed',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          color: const Color(0xFF1A2B5E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            height: 1.45,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'Your order '),
                            TextSpan(
                              text: '#${c.shortOrderId}',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' has been received. No payment was collected in this demo.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      OrderConfirmationSummaryCard(controller: c),
                      const SizedBox(height: 24),
                      OrderConfirmationDeliverySection(
                        address: c.shippingAddress,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: c.continueShopping,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A2B5E),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Continue Shopping',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: c.backToHome,
                          icon: const Icon(
                            Icons.home_outlined,
                            color: Color(0xFF1A2B5E),
                          ),
                          label: Text(
                            'Back to Home',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A2B5E),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.lightBlueSoft,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
