import 'package:shared_preferences/shared_preferences.dart';

/// Persists lightweight session metadata (Firebase Auth holds the real token).
class SessionStorage {
  static const _keyUid = 'atelier_session_uid';
  static const _keyEmail = 'atelier_session_email';

  Future<void> saveSession({required String uid, required String email}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyUid, uid);
    await p.setString(_keyEmail, email);
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyUid);
    await p.remove(_keyEmail);
  }

  Future<String?> get cachedEmail async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyEmail);
  }

  Future<String?> get cachedUid async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyUid);
  }
}
