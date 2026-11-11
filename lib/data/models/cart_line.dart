import 'package:mine_ecommerce/data/models/product_model.dart';

class CartLine {
  CartLine({required this.product, this.variantLabel = '', this.quantity = 1});

  final ProductModel product;
  final String variantLabel;
  int quantity;

  double get lineTotal => product.price * quantity;
}
