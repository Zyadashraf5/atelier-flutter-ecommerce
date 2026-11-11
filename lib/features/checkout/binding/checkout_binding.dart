import 'package:get/get.dart';
import 'package:mine_ecommerce/features/checkout/controller/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(CheckoutController.new);
  }
}
