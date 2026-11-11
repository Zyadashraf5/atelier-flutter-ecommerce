import 'package:get/get.dart';
import 'package:mine_ecommerce/core/constants/app_images.dart';
import 'package:mine_ecommerce/data/models/product_model.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/catalog/controller/catalog_controller.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class ProductDetailController extends GetxController {
  late ProductModel product;
  final thumbUrls = <String>[];

  int thumbIndex = 0;
  int quantity = 1;

  String get description => product.description.isEmpty
      ? 'Thoughtfully designed piece from the Atelier collection.'
      : product.description;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product = args;
      _applyThumbs();
    } else if (args is Map && args['productId'] is String) {
      product = const ProductModel(
        id: '_loading',
        name: 'Loading…',
        price: 0,
        imageUrl: AppImages.heroWatch,
      );
      thumbUrls.clear();
      _loadById(args['productId'] as String);
    } else {
      product = const ProductModel(
        id: 'nomad',
        name: 'The Nomad II \'Onyx\'',
        price: 285,
        imageUrl: AppImages.shoeMain,
        subtitle: 'LIMITED EDITION',
        description:
            'Handcrafted from top-grain calfskin with an ergonomic footbed.',
        isLimited: true,
        stockCount: 12,
        imageUrls: [AppImages.shoeMain, AppImages.shoe2, AppImages.shoe3],
      );
      _applyThumbs();
    }
  }

  Future<void> _loadById(String id) async {
    final catalog = Get.find<CatalogController>();
    final p = await catalog.fetchProductById(id);
    if (p != null) {
      product = p;
      _applyThumbs();
    } else {
      product = const ProductModel(
        id: 'missing',
        name: 'Product unavailable',
        price: 0,
        imageUrl: AppImages.heroWatch,
        stockCount: 0,
      );
      _applyThumbs();
    }
    update();
  }

  void _applyThumbs() {
    final urls = product.galleryUrls;
    thumbUrls
      ..clear()
      ..addAll(urls);
    if (thumbUrls.length < 2) {
      thumbUrls.addAll(
        [AppImages.shoe2, AppImages.lamp].where((u) => !thumbUrls.contains(u)),
      );
    }
  }

  void selectThumb(int i) {
    thumbIndex = i;
    update();
  }

  void incQty() {
    quantity++;
    update();
  }

  void decQty() {
    if (quantity > 1) {
      quantity--;
      update();
    }
  }

  void addToCart() {
    if (product.stockCount <= 0) {
      Get.snackbar('Atelier', 'This piece is out of stock.');
      return;
    }
    CartController.to.addProduct(product, quantity: quantity);
    Get.snackbar('Atelier', 'Added to cart');
    update();
  }

  void buyNow() {
    if (product.stockCount <= 0) {
      Get.snackbar('Atelier', 'This piece is out of stock.');
      return;
    }
    CartController.to.addProduct(product, quantity: quantity);
    Get.toNamed(AppRoutes.checkout);
  }

  void goHome() => Get.offNamed(AppRoutes.home);
  void goSearch() => Get.offNamed(AppRoutes.search);
  void goCart() => Get.offNamed(AppRoutes.cart);
}
