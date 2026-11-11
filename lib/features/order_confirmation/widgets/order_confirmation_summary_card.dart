import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/widgets/app_network_image.dart';
import 'package:mine_ecommerce/features/order_confirmation/controller/order_confirmation_controller.dart';
import 'package:mine_ecommerce/features/order_confirmation/widgets/order_confirmation_price_row.dart';

class OrderConfirmationSummaryCard extends StatelessWidget {
  const OrderConfirmationSummaryCard({super.key, required this.controller});

  final OrderConfirmationController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.chipUnselected,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Summary',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightBlueSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'PROCESSING',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 1,
                    color: const Color(0xFF1A2B5E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...c.items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: AppNetworkImage(url: e.imageUrl),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A2B5E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${e.price.toStringAsFixed(2)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
          OrderConfirmationPriceRow(
            label: 'Subtotal',
            value: '\$${c.subtotal.toStringAsFixed(2)}',
          ),
          OrderConfirmationPriceRow(
            label: 'Shipping',
            value: '\$${c.shipping.toStringAsFixed(2)}',
          ),
          OrderConfirmationPriceRow(
            label: 'Tax',
            value: '\$${c.tax.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: const Color(0xFF1A2B5E),
                ),
              ),
              Text(
                '\$${c.total.toStringAsFixed(2)}',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: const Color(0xFF1A2B5E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
