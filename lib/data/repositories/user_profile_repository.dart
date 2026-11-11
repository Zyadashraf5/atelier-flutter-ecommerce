import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore}) : _override = firestore;

  final FirebaseFirestore? _override;

  FirebaseFirestore get _db => _override ?? FirebaseFirestore.instance;

  Future<void> upsertProfile({
    required String uid,
    required String email,
    required String displayName,
  }) {
    return _db.collection('users').doc(uid).set({
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    return snap.data();
  }
}
