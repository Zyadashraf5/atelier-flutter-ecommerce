import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/responsive/app_responsive.dart';
import 'package:mine_ecommerce/core/widgets/atelier_bottom_nav.dart';
import 'package:mine_ecommerce/features/catalog/controller/catalog_controller.dart';
import 'package:mine_ecommerce/features/search/controller/search_controller.dart';
import 'package:mine_ecommerce/features/search/widgets/search_grid_product_card.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = AppResponsive.horizontalPadding(context);
    final crossCount = AppResponsive.gridCrossAxisCount(context);
    final mainSpace = AppResponsive.gridMainAxisSpacing(context);
    final crossSpace = AppResponsive.gridCrossAxisSpacing(context);
    final aspect = AppResponsive.searchGridChildAspectRatio(context);
    final headingSize = AppResponsive.scaleFont(context, 26);

    return GetBuilder<CatalogController>(
      builder: (_) {
        return GetBuilder<SearchController>(
          builder: (c) {
            final filtered = c.filteredProducts;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Padding(
                  padding: EdgeInsets.only(right: pad > 20 ? 8 : 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.navy,
                          size: 20,
                        ),
                        onPressed: Get.back,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.chipUnselected,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey.shade500,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: c.searchCtrl,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    isDense: true,
                                  ),
                                  onChanged: c.onSearchTextChanged,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: c.clearSearchAndShowAll,
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: pad >= 24 ? 20 : 16),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 52,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: pad),
                            scrollDirection: Axis.horizontal,
                            itemCount: c.chips.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (_, i) {
                              final sel = c.chipIndex == i;
                              return GestureDetector(
                                onTap: () => c.selectChip(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? AppColors.navy
                                        : AppColors.chipUnselected,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    c.chips[i],
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: sel
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(pad, 16, pad, 12),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  c.searchCtrl.text.isEmpty
                                      ? 'Browse'
                                      : c.searchCtrl.text,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w800,
                                    fontSize: headingSize,
                                    color: const Color(0xFF1A2442),
                                  ),
                                ),
                              ),
                              Text(
                                '${filtered.length} results',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(pad, 8, pad, 24),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossCount,
                                mainAxisSpacing: mainSpace,
                                crossAxisSpacing: crossSpace,
                                childAspectRatio: aspect,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (Get.find<CatalogController>().loading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (filtered.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'No products match. Try another category or search.',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }
                              final p = filtered[index];
                              return SearchGridProductCard(
                                product: p,
                                onTap: () => c.openProduct(p),
                              );
                            },
                            childCount: Get.find<CatalogController>().loading
                                ? 1
                                : (filtered.isEmpty ? 1 : filtered.length),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(pad, 8, pad, 8),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Trending Searches',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(pad, 0, pad, 100),
                        sliver: SliverToBoxAdapter(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: c.trending
                                .map(
                                  (t) => ActionChip(
                                    label: Text(
                                      t,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    backgroundColor: AppColors.chipUnselected,
                                    side: BorderSide.none,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    onPressed: () => c.applyTrending(t),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: const AtelierBottomNav(
                current: AtelierNavTab.search,
              ),
            );
          },
        );
      },
    );
  }
}
