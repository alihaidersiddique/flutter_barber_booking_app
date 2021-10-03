class SalonModel {
  String name = '', address = '';

  SalonModel({required this.name, required this.address});

  SalonModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    address = map['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
