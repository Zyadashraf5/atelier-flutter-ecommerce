import 'package:get/get.dart';
import 'package:mine_ecommerce/data/models/product_model.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/catalog/controller/catalog_controller.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class HomeController extends GetxController {
  int categoryIndex = 0;

  CatalogController get _catalog => Get.find<CatalogController>();

  List<String> get categories => _catalog.homeCategoryLabels;

  List<ProductModel> get visibleProducts {
    final cid = _catalog.categoryIdForHomeIndex(categoryIndex);
    final all = _catalog.products;
    if (cid == null) {
      return all;
    }
    return all.where((p) => p.categoryId == cid).toList();
  }

  void selectCategory(int i) {
    categoryIndex = i;
    update();
  }

  void openProduct(ProductModel p) {
    Get.toNamed(AppRoutes.productDetail, arguments: p);
  }

  void openSearch() => Get.toNamed(AppRoutes.search);

  void addQuickToCart(ProductModel p) {
    CartController.to.addProduct(p);
  }

  int get cartCount => CartController.to.itemCount;
}
