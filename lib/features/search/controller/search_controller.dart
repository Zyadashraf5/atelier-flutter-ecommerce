import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/data/models/product_model.dart';
import 'package:mine_ecommerce/features/catalog/controller/catalog_controller.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class SearchController extends GetxController {
  final searchCtrl = TextEditingController();

  int chipIndex = 0;

  /// When set, results use curated keywords instead of the literal search box text.
  String? _activeTrendingKey;

  final trending = <String>[
    'Brutalist Glassware',
    'Oak Sideboards',
    'Linen Bedding',
    'Architectural Lighting',
    'Sculptural Sconces',
  ];

  static const Map<String, List<String>> _trendingKeywords = {
    'Brutalist Glassware': [
      'vase',
      'ceramic',
      'bowl',
      'pitcher',
      'vessel',
      'porcelain',
      'glaze',
      'stoneware',
      'kintsugi',
      'ribbed',
      'earthen',
    ],
    'Oak Sideboards': [
      'chair',
      'lounge',
      'seat',
      'furniture',
      'velvet',
      'harlow',
      'seating',
      'upholstery',
    ],
    'Linen Bedding': [
      'pillow',
      'linen',
      'cushion',
      'textile',
      'fjord',
      'weave',
      'feather',
      'nomad',
      'calfskin',
      'leather',
    ],
    'Architectural Lighting': [
      'lamp',
      'light',
      'brass',
      'orbital',
      'led',
      'desk',
      'dimmable',
      'illuminat',
    ],
    'Sculptural Sconces': [
      'lamp',
      'light',
      'brass',
      'orbital',
      'architectural',
      'sconce',
      'fixture',
    ],
  };

  CatalogController get _catalog => Get.find<CatalogController>();

  List<String> get chips => _catalog.searchChipLabels;

  List<ProductModel> get filteredProducts {
    var list = _catalog.products;
    final cid = _catalog.categoryIdForSearchChipIndex(chipIndex);
    if (cid != null) {
      list = list.where((p) => p.categoryId == cid).toList();
    }

    if (_activeTrendingKey != null) {
      final kws = _trendingKeywords[_activeTrendingKey!] ??
          [_activeTrendingKey!.toLowerCase()];
      list = list.where((p) {
        final blob =
            '${p.name} ${p.subtitle} ${p.description}'.toLowerCase();
        return kws.any((k) => blob.contains(k));
      }).toList();
      return list;
    }

    final q = searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.subtitle.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q),
          )
          .toList();
    }
    return list;
  }

  void selectChip(int i) {
    chipIndex = i;
    update();
  }

  void applyTrending(String t) {
    chipIndex = 0;
    _activeTrendingKey = t;
    searchCtrl.value = TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
    update();
  }

  /// Clears query, category chip, and trending preset — shows full catalog in Search.
  void clearSearchAndShowAll() {
    chipIndex = 0;
    _activeTrendingKey = null;
    searchCtrl.clear();
    update();
  }

  void onSearchTextChanged(String _) {
    _activeTrendingKey = null;
    update();
  }

  void openProduct(ProductModel p) {
    Get.toNamed(AppRoutes.productDetail, arguments: p);
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
