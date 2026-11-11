import 'package:get/get.dart';
import 'package:mine_ecommerce/features/search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SearchController.new);
  }
}
