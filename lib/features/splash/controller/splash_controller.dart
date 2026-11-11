import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(milliseconds: 2800), () {
      unawaited(_goNextAsync());
    });
  }

  Future<void> _goNextAsync() async {
    var loggedIn = false;
    try {
      loggedIn =
          Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null;
    } catch (_) {}
    Get.offNamed(loggedIn ? AppRoutes.home : AppRoutes.login);
  }

  void enterShowroom() {
    _timer?.cancel();
    unawaited(_goNextAsync());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
