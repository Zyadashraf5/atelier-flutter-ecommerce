import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/core/services/session_storage.dart';
import 'package:mine_ecommerce/data/firestore/firestore_seeder.dart';
import 'package:mine_ecommerce/data/repositories/auth_repository.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool obscurePassword = true;
  bool submitting = false;

  final _auth = Get.find<AuthRepository>();
  final _session = SessionStorage();

  void togglePassword() {
    obscurePassword = !obscurePassword;
    update();
  }

  bool _validate() {
    final email = emailCtrl.text.trim();
    final pass = passwordCtrl.text;
    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar('Atelier', 'Enter a valid email.');
      return false;
    }
    if (pass.length < 6) {
      Get.snackbar('Atelier', 'Password must be at least 6 characters.');
      return false;
    }
    return true;
  }

  Future<void> signIn() async {
    if (!_validate()) {
      return;
    }
    submitting = true;
    update();
    try {
      final cred = await _auth.signInWithEmail(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );
      final u = cred.user!;
      await _session.saveSession(uid: u.uid, email: u.email ?? '');
      await FirestoreSeeder.ensureCatalogReady();
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Sign in failed', e.message ?? e.code);
    } catch (e) {
      Get.snackbar('Sign in failed', e.toString());
    } finally {
      submitting = false;
      update();
    }
  }

  void goRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void forgotPassword() {
    Get.snackbar('Atelier', 'Reset link would be sent to your email.');
  }

  void socialGoogle() {
    Get.snackbar('Atelier', 'Continue with Google');
  }

  void socialApple() {
    Get.snackbar('Atelier', 'Continue with Apple');
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
