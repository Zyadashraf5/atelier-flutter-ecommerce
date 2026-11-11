/// Money rules for an order: tax rate, shipping and rounding to the cent.
///
/// The cart, the checkout screen and the order written to Firestore all read
/// their numbers from here, so the amounts a customer sees are the amounts
/// that get stored.
class OrderPricing {
  const OrderPricing({this.taxRate = 0.08, this.flatShipping = 0});

  /// Sales tax applied to the subtotal.
  final double taxRate;

  /// Flat shipping fee charged on a non-empty cart (free in this store).
  final double flatShipping;

  /// Rounds a money amount to two decimals.
  static double roundMoney(double value) => (value * 100).roundToDouble() / 100;

  double shippingFor(double subtotal) => subtotal > 0 ? flatShipping : 0;

  double taxFor(double subtotal) => roundMoney(subtotal * taxRate);

  double totalFor(double subtotal) =>
      roundMoney(subtotal + shippingFor(subtotal) + taxFor(subtotal));
}
