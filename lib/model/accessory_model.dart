

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
    this.brandId,
    this.typeId,
  });

  AccessoryModel copyWith({
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
    String? image,
  }) {
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
    );
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
      soldQuantity: json['soldQuantity'],
      inputQuantity: json['inputQuantity'],
      rentalQuantity: json['rentalQuantity'],
      image: json['image'],
    );
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
