import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/features/checkout/controller/checkout_controller.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_field_label.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_floating_purchase_bar.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_order_summary_section.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_pay_tile.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_phone_field.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_plain_text_field.dart';
import 'package:mine_ecommerce/features/checkout/widgets/checkout_section_header.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = AppResponsive.horizontalPadding(context);
    return GetBuilder<CheckoutController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.navy,
                size: 20,
              ),
              onPressed: Get.back,
            ),
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
                onPressed: () => Get.toNamed(AppRoutes.cart),
              ),
            ],
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(pad, 0, pad, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Checkout',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            color: const Color(0xFF1B2B5B),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const CheckoutSectionHeader(
                          icon: Icons.location_on_outlined,
                          title: 'SHIPPING DETAILS',
                        ),
                        const SizedBox(height: 14),
                        const CheckoutFieldLabel('FULL NAME'),
                        const SizedBox(height: 6),
                        CheckoutPlainTextField(controller: c.nameCtrl),
                        const SizedBox(height: 14),
                        const CheckoutFieldLabel('STREET ADDRESS'),
                        const SizedBox(height: 6),
                        CheckoutPlainTextField(controller: c.streetCtrl),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CheckoutFieldLabel('CITY'),
                                  const SizedBox(height: 6),
                                  CheckoutPlainTextField(
                                    controller: c.cityCtrl,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CheckoutFieldLabel('POSTAL CODE'),
                                  const SizedBox(height: 6),
                                  CheckoutPlainTextField(
                                    controller: c.postalCtrl,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const CheckoutSectionHeader(
                          icon: Icons.phone_outlined,
                          title: 'CONTACT INFORMATION',
                        ),
                        const SizedBox(height: 14),
                        const CheckoutFieldLabel('PHONE NUMBER'),
                        const SizedBox(height: 6),
                        CheckoutPhoneField(controller: c.phoneCtrl),
                        const SizedBox(height: 26),
                        const CheckoutSectionHeader(
                          icon: Icons.credit_card_rounded,
                          title: 'PAYMENT PREFERENCE',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CheckoutPayTile(
                                selected: c.paymentMethod == 0,
                                icon: Icons.credit_card_rounded,
                                label: 'CREDIT CARD',
                                onTap: () => c.selectPayment(0),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CheckoutPayTile(
                                selected: c.paymentMethod == 1,
                                icon: Icons.account_balance_wallet_outlined,
                                label: 'DIGITAL PAY',
                                onTap: () => c.selectPayment(1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        CheckoutOrderSummarySection(checkout: c),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: c.submitting ? null : c.submitOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B2B5B),
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit Order',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'DEMO CHECKOUT · NO PAYMENT WILL BE COLLECTED',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              const CheckoutFloatingPurchaseBar(),
            ],
          ),
        );
      },
    );
  }
}
