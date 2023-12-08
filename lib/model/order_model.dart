class OrderModel {
  String? id;
  Map? createBy;
  String? nameCustomer;
  String? phone;
  String? address;
  List? products;
  int? totalCostOfProducts;
  int? totalAmount;
  String? status;
  String? createdAt;

  OrderModel({
    this.id,
    this.createBy,
    this.nameCustomer,
    this.phone,
    this.address,
    this.products,
    this.totalCostOfProducts,
    this.totalAmount,
    this.status,
    this.createdAt,
  });

  static OrderModel fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      createBy: json['createBy'],
      nameCustomer: json['nameCustomer'],
      phone: json['phone'],
      address: json['address'],
      products: json['products'],
      totalCostOfProducts: json['totalCostOfProducts'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      createdAt: json['createdAt'] ?? DateTime.now(),
    );
  }
}
