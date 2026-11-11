import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/core/services/session_storage.dart';
import 'package:mine_ecommerce/data/repositories/auth_repository.dart';
import 'package:mine_ecommerce/data/repositories/user_profile_repository.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class RegisterController extends GetxController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool obscurePassword = true;
  bool agreeTerms = false;
  bool submitting = false;

  final _auth = Get.find<AuthRepository>();
  final _profiles = Get.find<UserProfileRepository>();
  final _session = SessionStorage();

  void togglePassword() {
    obscurePassword = !obscurePassword;
    update();
  }

  void toggleAgree(bool? v) {
    agreeTerms = v ?? false;
    update();
  }

  bool _validate() {
    if (!agreeTerms) {
      Get.snackbar('Atelier', 'Please agree to the Terms and Privacy Policy.');
      return false;
    }
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Atelier', 'Enter your name.');
      return false;
    }
    final email = emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar('Atelier', 'Enter a valid email.');
      return false;
    }
    final pass = passwordCtrl.text;
    if (pass.length < 6) {
      Get.snackbar('Atelier', 'Password must be at least 6 characters.');
      return false;
    }
    if (pass != confirmCtrl.text) {
      Get.snackbar('Atelier', 'Passwords do not match.');
      return false;
    }
    return true;
  }

  Future<void> register() async {
    if (!_validate()) {
      return;
    }
    submitting = true;
    update();
    try {
      final cred = await _auth.registerWithEmail(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );
      final u = cred.user!;
      await u.updateDisplayName(nameCtrl.text.trim());
      await _profiles.upsertProfile(
        uid: u.uid,
        email: u.email ?? emailCtrl.text.trim(),
        displayName: nameCtrl.text.trim(),
      );
      await _session.saveSession(uid: u.uid, email: u.email ?? '');
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration failed', e.message ?? e.code);
    } catch (e) {
      Get.snackbar('Registration failed', e.toString());
    } finally {
      submitting = false;
      update();
    }
  }

  void goLogin() {
    Get.offNamed(AppRoutes.login);
  }

  void socialGoogle() => Get.snackbar('Atelier', 'Sign up with Google');

  void socialApple() => Get.snackbar('Atelier', 'Sign up with Apple');

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }
}
