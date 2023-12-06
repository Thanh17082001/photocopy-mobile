class OrderModel {
  String? createBy;
  String? nameCustomer;
  String? phone;
  String? address;
  List? products;
  int? totalCostOfProducts;
  int? totalAmount;
  String? status;

  OrderModel(
      {this.createBy,
      this.nameCustomer,
      this.phone,
      this.address,
      this.products,
      this.totalCostOfProducts,
      this.totalAmount,
      this.status});

  static OrderModel fromJson(Map<String, dynamic> json) {
    return OrderModel(
        createBy: json['createBy'],
        nameCustomer: json['nameCustomer'],
        phone: json['phone'],
        address: json['address'],
        products: json['products'],
        totalCostOfProducts: json['totalCostOfProducts'],
        totalAmount: json['totalAmount'],
        status: json['status']);
  }
}
