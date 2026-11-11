import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mine_ecommerce/data/models/cart_line.dart';

class OrderRepository {
  OrderRepository({FirebaseFirestore? firestore}) : _override = firestore;

  final FirebaseFirestore? _override;

  FirebaseFirestore get _db => _override ?? FirebaseFirestore.instance;

  Future<String> createOrder({
    required String userId,
    required List<CartLine> lines,
    required String fullName,
    required String street,
    required String city,
    required String postal,
    required String phone,
    required int paymentMethodIndex,
    required double subtotal,
    required double tax,
    required double total,
  }) async {
    final lineMaps = lines
        .map(
          (l) => {
            'productId': l.product.id,
            'name': l.product.name,
            'subtitle': l.variantLabel.isEmpty
                ? (l.product.subtitle)
                : l.variantLabel,
            'imageUrl': l.product.imageUrl,
            'quantity': l.quantity,
            'unitPrice': l.product.price,
            'lineTotal': l.lineTotal,
          },
        )
        .toList();

    final doc = await _db.collection('orders').add({
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'processing',
      'paymentMethodIndex': paymentMethodIndex,
      'lines': lineMaps,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'shipping': {
        'fullName': fullName,
        'street': street,
        'city': city,
        'postal': postal,
        'phone': phone,
      },
    });
    return doc.id;
  }
}
