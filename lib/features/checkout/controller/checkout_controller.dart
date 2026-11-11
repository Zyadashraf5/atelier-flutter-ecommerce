import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/data/models/cart_line.dart';
import 'package:mine_ecommerce/data/repositories/order_repository.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class CheckoutLineUi {
  const CheckoutLineUi({
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

class CheckoutController extends GetxController {
  final nameCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final postalCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  int paymentMethod = 0;
  bool submitting = false;

  double get subtotal =>
      CartController.to.lines.isEmpty ? 0.0 : CartController.to.subtotal;

  // Shown on the checkout screen; read from the cart so the screen and the
  // saved order always use the same rounded amounts.
  double get shipping => CartController.to.shipping;

  double get tax => CartController.to.tax;

  double get total => CartController.to.total;

  void selectPayment(int i) {
    paymentMethod = i;
    update();
  }

  void completePurchaseFab() => submitOrder();

  Future<void> submitOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar(
        'Sign in required',
        'Please sign in to complete your order.',
      );
      await Get.toNamed(AppRoutes.login);
      return;
    }
    if (CartController.to.lines.isEmpty) {
      Get.snackbar('Cart is empty', 'Add items to your cart before checkout.');
      return;
    }
    submitting = true;
    update();
    try {
      final cart = CartController.to;
      final lines = List<CartLine>.from(cart.lines);
      final sub = cart.subtotal;
      final taxAmt = cart.tax;
      final ship = cart.shipping;
      final tot = cart.total;

      final itemPayload = lines
          .map(
            (l) => {
              'title': l.product.name,
              'subtitle': l.variantLabel.isEmpty
                  ? l.product.subtitle
                  : l.variantLabel,
              'price': l.lineTotal,
              'imageUrl': l.product.imageUrl,
            },
          )
          .toList();

      final orderRepo = Get.find<OrderRepository>();
      final id = await orderRepo.createOrder(
        userId: user.uid,
        lines: lines,
        fullName: nameCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        city: cityCtrl.text.trim(),
        postal: postalCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        paymentMethodIndex: paymentMethod,
        subtotal: sub,
        tax: taxAmt,
        total: tot,
      );

      cart.clear();

      Get.offNamed(
        AppRoutes.orderConfirmation,
        arguments: {
          'orderId': id,
          'subtotal': sub,
          'shipping': ship,
          'tax': taxAmt,
          'total': tot,
          'items': itemPayload,
        },
      );
    } catch (e) {
      Get.snackbar('Checkout failed', e.toString());
    } finally {
      submitting = false;
      update();
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    postalCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
