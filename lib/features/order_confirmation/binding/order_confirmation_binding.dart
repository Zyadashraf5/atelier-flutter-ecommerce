import 'package:get/get.dart';
import 'package:mine_ecommerce/features/order_confirmation/controller/order_confirmation_controller.dart';

class OrderConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(OrderConfirmationController.new);
  }
}
