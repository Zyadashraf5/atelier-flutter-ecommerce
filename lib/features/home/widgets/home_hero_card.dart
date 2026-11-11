import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/constants/app_images.dart';
import 'package:mine_ecommerce/core/widgets/app_network_image.dart';

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({super.key, required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.heroBeige,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'THE ATELIER EDIT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Objects for everyday living.',
                  maxLines: 3,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    height: 1.15,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onExplore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Explore'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 0.85,
              child: AppNetworkImage(
                url: AppImages.chair,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
