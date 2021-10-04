import 'package:cloud_firestore/cloud_firestore.dart';

class BarberModel {
  String userName = '', name = '', docId = '';
  double rating = 0.0;
  int ratingTimes = 0;

  late DocumentReference reference;

  BarberModel();

  BarberModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    userName = map['userName'];
    rating =
        double.parse(map['rating'] == null ? '0' : map['rating'].toString());
    ratingTimes = int.parse(
        map['ratingTimes'] == null ? '0' : map['ratingTimes'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['rating'] = this.rating;
    data['ratingTimes'] = this.ratingTimes;
    return data;
  }
}
