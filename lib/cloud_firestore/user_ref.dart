import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barber_booking_app/models/user_model.dart';

Future<UserModel> getUserProfiles(String? phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();

  if (snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>;
    var userModel = UserModel.fromJson(data);
    return userModel;
  } else
    return UserModel(name: '', address: '');
}
