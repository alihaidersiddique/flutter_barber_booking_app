class UserModel {
  String name = '', address = '';

  UserModel({required this.name, required this.address});

  UserModel.fromJson(Map<String, dynamic> map) {
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
