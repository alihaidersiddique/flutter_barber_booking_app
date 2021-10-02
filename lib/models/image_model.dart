class ImageModel {
  String image = '';

  ImageModel({required this.image});

  ImageModel.fromJson(Map<String, dynamic> map) {
    image = map['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
