import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/core/services/session_storage.dart';
import 'package:mine_ecommerce/data/repositories/auth_repository.dart';
import 'package:mine_ecommerce/data/repositories/user_profile_repository.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

class ProfileController extends GetxController {
  static const defaultAvatarUrl =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=85';

  final _auth = Get.find<AuthRepository>();
  final _profiles = Get.find<UserProfileRepository>();
  final _session = SessionStorage();

  String displayName = '';
  String email = '';

  /// Firebase `photoURL` when set; otherwise a stable portrait placeholder (Unsplash).
  String get avatarDisplayUrl {
    final url = FirebaseAuth.instance.currentUser?.photoURL;
    if (url != null && url.trim().isNotEmpty) {
      return url.trim();
    }
    return defaultAvatarUrl;
  }

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) {
      displayName = '';
      email = '';
      update();
      return;
    }
    email = u.email ?? '';
    displayName = u.displayName ?? '';
    try {
      final doc = await _profiles.getProfile(u.uid);
      if (doc != null) {
        displayName = doc['displayName'] as String? ?? displayName;
        email = doc['email'] as String? ?? email;
      }
    } catch (_) {}
    update();
  }

  void onMenuTap(String label) {
    Get.snackbar('Atelier', '$label — coming soon');
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _session.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
