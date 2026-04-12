import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  UserService({FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _firestoreClient => _firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestoreClient.collection('users');

  Future<UserModel?> getUserByUid(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return UserModel.fromMap(doc.data()!);
  }

  Stream<List<UserModel>> streamUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList(growable: false);
    });
  }

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    String role = 'user',
  }) async {
    final user = UserModel(uid: uid, name: name, email: email, role: role);
    await _usersCollection.doc(uid).set(user.toMap());
  }

  Future<void> updateUser({
    required String uid,
    required String name,
    required String role,
  }) async {
    await _usersCollection.doc(uid).update({'name': name, 'role': role});
  }

  Future<void> deleteUser(String uid) async {
    await _usersCollection.doc(uid).delete();
  }
}
