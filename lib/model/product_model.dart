class ProductModel {
  final String? id;
  final String? brandId;
  final String? typeId;
  final String categoryId;
  final String? name;
  final String? description;
  final String? image;
  final int? soldQuantity;
  final int? inputQuantity;
  final int? rentalQuantity;
  final int? priceSale;
  final int? priceRental;
  final int? warrantyTime;
  final String typeProduct;
// hàm xây dưng
  ProductModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.soldQuantity,
    this.inputQuantity,
    this.rentalQuantity,
    this.priceSale,
    this.priceRental,
    this.warrantyTime,
    this.brandId,
    this.typeId,
    this.typeProduct='product',
    required this.categoryId,
  });

  ProductModel copyWith({
    String? id,
    String? brandId,
    String? typeId,
    String? categoryId,
    String? name,
    String? description,
    int? soldQuantity,
    int? rentalQuantity,
    int? priceSale,
    int? priceRental,
    int? warrantyTime,
    String? image,
    String? typeProduct,
  }) {
    return ProductModel(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      typeId: typeId ?? this.typeId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      priceSale: priceSale ?? this.priceSale,
      priceRental: priceRental ?? this.priceRental,
      warrantyTime: warrantyTime ?? this.warrantyTime,
      soldQuantity: soldQuantity ?? this.soldQuantity,
      rentalQuantity: rentalQuantity ?? this.rentalQuantity,
      image: image ?? this.image,
      typeProduct: typeProduct ?? 'product'
    );
  }

  // chuyển từ json sang ob dart
  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      brandId: json['brandId'],
      typeId: json['typeId'],
      categoryId: json['categoryId'],
      name: json['name'],
      description: json['description'],
      priceSale: json['priceSale'],
      priceRental: json['priceRental'],
      warrantyTime: json['warrantyTime'],
      soldQuantity: json['soldQuantity'],
      inputQuantity: json['inputQuantity'],
      rentalQuantity: json['rentalQuantity'],
      image: json['image'],
      typeProduct: 'product'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'priceSale': priceSale,
      'priceRental': priceRental,
      'warrantyTime': warrantyTime,
      'soldQuantity': soldQuantity,
      'inputQuantity': inputQuantity,
      'rentalQuantity': rentalQuantity,
      'image': image
    };
  }
}
