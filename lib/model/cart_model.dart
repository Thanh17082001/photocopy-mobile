class CartModel {
  String? id;
  String? userId;
  List? products;

  CartModel({this.id, this.userId, this.products});

  static CartModel? fromJson(json) {
    if (json!=null) {
    return CartModel(
      id: json['_id'],
      userId: json['userId'],
      products: json['products'],
    );
  }
    return null; 
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'userId': userId, 'products': products};
  }
}
