import 'package:admin_taag/models/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServise {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final QuerySnapshot snapshot = await firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

 Stream<List<UserModel>> fetchUsersStream() {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  return firestore.collection('users').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return UserModel(
        uId: doc.id,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        nation: data['nation'] ?? '',
        image: data['image'] ?? '',
        token: data['token'] ?? '',
      );
    }).toList();
  });
}
}
