import 'package:flutter_test/flutter_test.dart';
import 'package:mine_ecommerce/core/pricing/order_pricing.dart';
import 'package:mine_ecommerce/data/models/product_model.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';

const chair = ProductModel(id: 'p1', name: 'Oak chair', price: 120, imageUrl: '');
const vase = ProductModel(id: 'p2', name: 'Stone vase', price: 34.99, imageUrl: '');

void main() {
  group('OrderPricing', () {
    const pricing = OrderPricing();

    test('charges 8% tax rounded to the cent', () {
      expect(pricing.taxFor(120), 9.6);
      expect(pricing.taxFor(34.99), 2.8); // 2.7992 -> 2.80
      expect(pricing.taxFor(0), 0);
    });

    test('total is subtotal + shipping + tax, rounded to the cent', () {
      expect(pricing.totalFor(154.99), 167.39); // 154.99 + 12.3992 -> 167.39
      expect(pricing.totalFor(0), 0);
    });

    test('shipping only applies to a non-empty cart', () {
      const paid = OrderPricing(flatShipping: 5);
      expect(paid.shippingFor(0), 0);
      expect(paid.shippingFor(10), 5);
      expect(paid.totalFor(10), 15.8);
    });
  });

  group('CartController', () {
    late CartController cart;

    setUp(() => cart = CartController());

    test('adding the same product and variant merges the lines', () {
      cart.addProduct(chair);
      cart.addProduct(chair, quantity: 2);
      cart.addProduct(chair, variant: 'Walnut');

      expect(cart.lines, hasLength(2));
      expect(cart.lines.first.quantity, 3);
      expect(cart.itemCount, 4);
    });

    test('a quantity below one is ignored when adding', () {
      cart.addProduct(chair, quantity: 0);
      cart.addProduct(chair, quantity: -2);
      expect(cart.lines, isEmpty);
    });

    test('setting a quantity below one removes the line', () {
      cart.addProduct(chair);
      cart.addProduct(vase);
      cart.setQuantity(0, 0);
      expect(cart.lines.single.product.id, 'p2');
    });

    test('out-of-range indexes are ignored', () {
      cart.addProduct(chair);
      cart.setQuantity(5, 2);
      cart.removeAt(-1);
      expect(cart.lines.single.quantity, 1);
    });

    test('totals use the shared pricing rules', () {
      cart.addProduct(chair);
      cart.addProduct(vase);

      expect(cart.subtotal, closeTo(154.99, 1e-9));
      expect(cart.tax, 12.4);
      expect(cart.shipping, 0);
      expect(cart.total, 167.39);
      expect(cart.total, CartController.pricing.totalFor(cart.subtotal));
    });

    test('an empty cart costs nothing', () {
      expect(cart.subtotal, 0);
      expect(cart.tax, 0);
      expect(cart.total, 0);
    });
  });
}
