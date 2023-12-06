import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photocopy/model/product_model.dart';
import '../../service/product_service.dart';

class ProductManager with ChangeNotifier {
  final ProductService productService = ProductService();
  List<ProductModel> _items = [];

  List<ProductModel> get products {
    return [..._items];
  }

  Future fetchproducts() async {
    _items = (await productService.getAll())!;
    notifyListeners();
  }

  Future search(searchValue) async {
    try {
      _items = (await productService.search(searchValue))!;
      notifyListeners();
    } catch (e) {
      return null;
    }
  }

  int get itemAcount {
    return _items.length;
  }

  ProductModel findById(String id) {
    fetchproducts();
    if (_items.isNotEmpty) {
      return _items.firstWhere((product) => product.id == id);
    } else {
      return ProductModel();
    }
  }

  Future findByIdBrand(String brandId) async {
    try {
      _items = (await productService.getByBrandId(brandId))!;
      notifyListeners();
    } catch (err) {
      return;
    }
  }
}
