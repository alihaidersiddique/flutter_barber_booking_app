import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barber_booking_app/models/image_model.dart';

Future<List<ImageModel>> getLookbook() async {
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);

  CollectionReference lookbookRef =
      FirebaseFirestore.instance.collection('Lookbook');
  QuerySnapshot snapshot = await lookbookRef.get();

  snapshot.docs.forEach((element) {
    final data = element.data() as Map<String, dynamic>;
    result.add(ImageModel.fromJson(data));
  });

  return result;
}
