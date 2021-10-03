class CityModel {
  String name = '';

  CityModel({required this.name});

  CityModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
