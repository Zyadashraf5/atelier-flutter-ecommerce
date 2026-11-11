import 'package:get/get.dart';
import 'package:mine_ecommerce/core/pricing/order_pricing.dart';
import 'package:mine_ecommerce/data/models/cart_line.dart';
import 'package:mine_ecommerce/data/models/product_model.dart';

/// Shared cart — registered as permanent in [InitialBinding].
class CartController extends GetxController {
  static CartController get to => Get.find<CartController>();

  final List<CartLine> lines = [];

  int get itemCount => lines.fold(0, (a, b) => a + b.quantity);

  double get subtotal => lines.fold(0.0, (a, b) => a + b.lineTotal);

  /// Pricing rules shared by the cart, the checkout screen and the saved order.
  static const pricing = OrderPricing();

  double get shipping => pricing.shippingFor(subtotal);

  double get tax => pricing.taxFor(subtotal);

  double get total => pricing.totalFor(subtotal);

  void addProduct(
    ProductModel product, {
    String variant = '',
    int quantity = 1,
  }) {
    if (quantity < 1) return;
    final i = lines.indexWhere(
      (l) => l.product.id == product.id && l.variantLabel == variant,
    );
    if (i >= 0) {
      lines[i].quantity += quantity;
    } else {
      lines.add(
        CartLine(product: product, variantLabel: variant, quantity: quantity),
      );
    }
    update();
  }

  void setQuantity(int index, int q) {
    if (index < 0 || index >= lines.length) return;
    if (q < 1) {
      lines.removeAt(index);
    } else {
      lines[index].quantity = q;
    }
    update();
  }

  void removeAt(int index) {
    if (index < 0 || index >= lines.length) return;
    lines.removeAt(index);
    update();
  }

  void clear() {
    lines.clear();
    update();
  }
}
