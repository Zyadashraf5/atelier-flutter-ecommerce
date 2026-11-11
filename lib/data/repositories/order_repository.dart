import 'package:cloud_functions/cloud_functions.dart';
import 'package:mine_ecommerce/data/models/cart_line.dart';

class CreatedOrder {
  const CreatedOrder({
    required this.id,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.items,
    required this.shippingAddress,
  });
  final String id;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final List<Map<String, dynamic>> items;
  final Map<String, String> shippingAddress;

  factory CreatedOrder.fromMap(Map<String, dynamic> data) {
    return CreatedOrder(
      id: data['orderId'] as String,
      shippingAddress: Map<String, String>.from(data['shippingAddress'] as Map),
      subtotal: (data['subtotal'] as num).toDouble(),
      tax: (data['tax'] as num).toDouble(),
      shipping: (data['shipping'] as num).toDouble(),
      total: (data['total'] as num).toDouble(),
      items: (data['lines'] as List).map((raw) {
        final line = Map<String, dynamic>.from(raw as Map);
        return <String, dynamic>{
          'title': line['name'],
          'subtitle': line['subtitle'],
          'price': (line['lineTotal'] as num).toDouble(),
          'imageUrl': line['imageUrl'],
        };
      }).toList(),
    );
  }
}

class OrderRepository {
  OrderRepository({FirebaseFunctions? functions}) : _override = functions;
  final FirebaseFunctions? _override;

  Future<CreatedOrder> createOrder({
    required String requestId,
    required List<CartLine> lines,
    required String fullName,
    required String street,
    required String city,
    required String postal,
    required String phone,
    required int paymentMethodIndex,
  }) async {
    // Identity, prices, stock, totals and status are enforced by the callable.
    final response = await (_override ?? FirebaseFunctions.instance)
        .httpsCallable('placeOrder')
        .call({
          'requestId': requestId,
          'lines': lines
              .map(
                (line) => {
                  'productId': line.product.id,
                  'quantity': line.quantity,
                  'variantLabel': line.variantLabel,
                },
              )
              .toList(),
          'shipping': {
            'fullName': fullName,
            'street': street,
            'city': city,
            'postal': postal,
            'phone': phone,
          },
          'paymentMethodIndex': paymentMethodIndex,
        });
    return CreatedOrder.fromMap(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
