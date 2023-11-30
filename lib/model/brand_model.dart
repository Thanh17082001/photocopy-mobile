class BrandModel {
  final String? id;
  final String? name;
  final String? image;

  BrandModel({this.id, this.name, this.image});

  static BrandModel fromJson(Map<String, dynamic> json) {
    return BrandModel(
        id: json['_id'], name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson(BrandModel brand) {
    return {
      '_id':id,
      "name":name,
      'image':image
    };
  }
}
