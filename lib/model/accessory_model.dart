class AccessoryModel {
  final String? id;
  final String? brandId;
  final String? typeId;
  final String? name;
  final String? description;
  final String? image;
  final int? soldQuantity;
  final int? inputQuantity;
  final int? rentalQuantity;
  final int? priceSale;
  final int? priceRental;
  final int? priceImport;
  final String typeProduct;
// hàm xây dưng
  AccessoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.soldQuantity,
    this.inputQuantity,
    this.rentalQuantity,
    this.priceSale,
    this.priceRental,
    this.priceImport,
    this.brandId,
    this.typeId,
    this.typeProduct = 'accessory',
  });

  AccessoryModel copyWith(
      {String? id,
      String? brandId,
      String? typeId,
      String? categoryId,
      String? name,
      String? description,
      int? soldQuantity,
      int? rentalQuantity,
      int? priceSale,
      int? priceRental,
      String? image,
      String? typeProduct}) {
    return AccessoryModel(
        id: id ?? this.id,
        brandId: brandId ?? this.brandId,
        typeId: typeId ?? this.typeId,
        name: name ?? this.name,
        description: description ?? this.description,
        priceSale: priceSale ?? this.priceSale,
        priceRental: priceRental ?? this.priceRental,
        soldQuantity: soldQuantity ?? this.soldQuantity,
        rentalQuantity: rentalQuantity ?? this.rentalQuantity,
        image: image ?? this.image,
        typeProduct: typeProduct ?? 'accessory');
  }

  // chuyển từ json sang ob dart
  static AccessoryModel fromJson(Map<String, dynamic> json) {
    return AccessoryModel(
        id: json['_id'],
        brandId: json['brandId'],
        typeId: json['typeId'],
        name: json['name'],
        description: json['description'],
        priceSale: json['priceSale'],
        priceRental: json['priceRental'],
        priceImport: json['priceImport'],
        soldQuantity: json['soldQuantity'],
        inputQuantity: json['inputQuantity'],
        rentalQuantity: json['rentalQuantity'],
        image: json['image'],
        typeProduct: 'accessory');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'priceSale': priceSale,
      'priceRental': priceRental,
      'soldQuantity': soldQuantity,
      'inputQuantity': inputQuantity,
      'rentalQuantity': rentalQuantity,
      'image': image
    };
  }
}
