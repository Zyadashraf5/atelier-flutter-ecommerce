import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/core/widgets/atelier_bottom_nav.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/catalog/controller/catalog_controller.dart';
import 'package:mine_ecommerce/features/home/controller/home_controller.dart';
import 'package:mine_ecommerce/features/home/widgets/home_category_chip.dart';
import 'package:mine_ecommerce/features/home/widgets/home_hero_card.dart';
import 'package:mine_ecommerce/features/home/widgets/home_product_list_tile.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = AppResponsive.horizontalPadding(context);
    final titleSize = AppResponsive.scaleFont(context, 22);

    return GetBuilder<CatalogController>(
      builder: (_) {
        return GetBuilder<HomeController>(
          builder: (c) {
            final catalog = Get.find<CatalogController>();
            final productListChildCount =
                catalog.loading || catalog.errorMessage != null
                ? 1
                : (c.visibleProducts.isEmpty ? 1 : c.visibleProducts.length);

            return Scaffold(
              backgroundColor: const Color(0xFFF8F8F8),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'Atelier',
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.w700,
                    fontSize: titleSize,
                    color: AppColors.navy,
                  ),
                ),
                actions: [
                  GetBuilder<CartController>(
                    builder: (cart) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.navy,
                            ),
                            onPressed: () => Get.toNamed(AppRoutes.cart),
                          ),
                          if (cart.itemCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: AppColors.navy,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cart.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(pad, 8, pad, 16),
                        sliver: SliverToBoxAdapter(
                          child: HomeHeroCard(
                            onExplore: () => c.selectCategory(0),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        sliver: SliverToBoxAdapter(
                          child: Material(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: c.openSearch,
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Search for crafted goods...',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textMuted,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(pad, 16, pad, 12),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (
                                  var i = 0;
                                  i < c.categories.length;
                                  i++
                                ) ...[
                                  if (i > 0) const SizedBox(width: 10),
                                  HomeCategoryChip(
                                    label: c.categories[i],
                                    selected: c.categoryIndex == i,
                                    onTap: () => c.selectCategory(i),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            if (catalog.loading) {
                              return const Padding(
                                padding: EdgeInsets.all(48),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (catalog.errorMessage != null) {
                              return Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  'Could not load catalog.\n${catalog.errorMessage}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              );
                            }
                            if (c.visibleProducts.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  'No products in this category yet. Add documents '
                                  'to the Firestore `products` collection.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              );
                            }
                            final p = c.visibleProducts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 28),
                              child: HomeProductListTile(
                                product: p,
                                onTap: () => c.openProduct(p),
                                onAddCart: () => c.addQuickToCart(p),
                              ),
                            );
                          }, childCount: productListChildCount),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 88)),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: const AtelierBottomNav(
                current: AtelierNavTab.home,
              ),
            );
          },
        );
      },
    );
  }
}
