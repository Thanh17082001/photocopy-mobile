class CartModel {
  String? id;
  String? userId;
  List? products;

  CartModel({this.id, this.userId, this.products});

  static CartModel fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['_id'], userId: json['userId'], products: json['products']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'userId': userId, 'products': products};
  }
}
