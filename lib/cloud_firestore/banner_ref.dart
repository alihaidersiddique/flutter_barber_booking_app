import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barber_booking_app/models/image_model.dart';

Future<List<ImageModel>> getBanners() async {
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);

  CollectionReference bannerRef =
      FirebaseFirestore.instance.collection('Banner');
  QuerySnapshot snapshot = await bannerRef.get();

  snapshot.docs.forEach((element) {
    final data = element.data() as Map<String, dynamic>;
    result.add(ImageModel.fromJson(data));
  });

  return result;
}
