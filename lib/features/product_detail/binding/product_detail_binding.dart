import 'package:get/get.dart';
import 'package:mine_ecommerce/features/product_detail/controller/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ProductDetailController.new);
  }
}
