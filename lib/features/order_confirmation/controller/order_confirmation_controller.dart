import 'package:get/get.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class OrderLineUi {
  const OrderLineUi({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final double price;
  final String imageUrl;
}

class OrderConfirmationController extends GetxController {
  String orderId = '';
  Map<String, String> shippingAddress = {};
  String get shortOrderId =>
      orderId.length > 12 ? orderId.substring(0, 12) : orderId;
  double total = 0;
  double subtotal = 0;
  double shipping = 0;
  double tax = 0;

  final items = <OrderLineUi>[];

  @override
  void onInit() {
    final a = Get.arguments;
    if (a is Map) {
      if (a['shippingAddress'] is Map) {
        shippingAddress = Map<String, String>.from(a['shippingAddress'] as Map);
      }
      final id = a['orderId'];
      if (id is String) {
        orderId = id;
      }
      final t = a['total'];
      if (t is num) {
        total = t.toDouble();
      }
      final st = a['subtotal'];
      if (st is num) {
        subtotal = st.toDouble();
      }
      final sh = a['shipping'];
      if (sh is num) {
        shipping = sh.toDouble();
      }
      final tx = a['tax'];
      if (tx is num) {
        tax = tx.toDouble();
      }
      final rawItems = a['items'];
      if (rawItems is List) {
        items.clear();
        for (final e in rawItems) {
          if (e is Map) {
            items.add(
              OrderLineUi(
                title: '${e['title'] ?? ''}',
                subtitle: '${e['subtitle'] ?? ''}',
                price: (e['price'] as num?)?.toDouble() ?? 0,
                imageUrl: '${e['imageUrl'] ?? ''}',
              ),
            );
          }
        }
      }
    }
    if (items.isNotEmpty && subtotal <= 0) {
      subtotal = items.fold(0.0, (a, b) => a + b.price);
    }
    if (total <= 0 && subtotal > 0) {
      total = subtotal + shipping + tax;
    }
    super.onInit();
  }

  void continueShopping() {
    Get.offAllNamed(AppRoutes.home);
  }

  void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}
