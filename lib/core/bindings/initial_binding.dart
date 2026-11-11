import 'package:get/get.dart';
import 'package:mine_ecommerce/data/repositories/auth_repository.dart';
import 'package:mine_ecommerce/data/repositories/order_repository.dart';
import 'package:mine_ecommerce/data/repositories/user_profile_repository.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/features/catalog/controller/catalog_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(), permanent: true);
    Get.put(UserProfileRepository(), permanent: true);
    Get.put(OrderRepository(), permanent: true);
    Get.put(CatalogController(), permanent: true);
    Get.put(CartController(), permanent: true);
  }
}
