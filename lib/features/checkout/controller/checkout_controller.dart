import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? _pendingRequestId;
  String? _pendingPayload;

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
    if (submitting) return;
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
      final orderRepo = Get.find<OrderRepository>();
      final payload = jsonEncode({
        'lines': lines
            .map((l) => [l.product.id, l.quantity, l.variantLabel])
            .toList(),
        'address': [
          nameCtrl.text.trim(),
          streetCtrl.text.trim(),
          cityCtrl.text.trim(),
          postalCtrl.text.trim(),
          phoneCtrl.text.trim(),
        ],
        'payment': paymentMethod,
      });
      if (_pendingPayload != payload) {
        _pendingRequestId = FirebaseFirestore.instance
            .collection('orders')
            .doc()
            .id;
        _pendingPayload = payload;
      }
      final saved = await orderRepo.createOrder(
        requestId: _pendingRequestId!,
        lines: lines,
        fullName: nameCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        city: cityCtrl.text.trim(),
        postal: postalCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        paymentMethodIndex: paymentMethod,
      );

      cart.clear();
      _pendingRequestId = null;
      _pendingPayload = null;

      Get.offNamed(
        AppRoutes.orderConfirmation,
        arguments: {
          'orderId': saved.id,
          'subtotal': saved.subtotal,
          'shipping': saved.shipping,
          'tax': saved.tax,
          'total': saved.total,
          'items': saved.items,
          'shippingAddress': saved.shippingAddress,
        },
      );
    } on FirebaseFunctionsException catch (e) {
      Get.snackbar('Could not place order', e.message ?? 'Please try again.');
    } catch (_) {
      Get.snackbar(
        'Could not place order',
        'Please check your connection and try again.',
      );
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
