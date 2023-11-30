import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class ProductService {
  Future<List<ProductModel>?> getAll() async {
    final List<ProductModel> products = [];
    const String ipDevice = "10.0.2.2";
    try {
      final url = Uri.parse("http://$ipDevice:3000/product/");
      final response = await http.get(url);
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        return [];
      } else {
        result.forEach((product) {
          if (product['inputQuantity'] > 0) {
            products.add(ProductModel.fromJson(product));
          }
        });
      }
      return products;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<ProductModel>?> getByBrandId(brandId) async {
    final List<ProductModel> products = [];
    const String ipDevice = "10.0.2.2";
    try {
      final url = Uri.parse(
          "http://$ipDevice:3000/product/get-brand-id/?brandId=$brandId");
      final response = await http.get(url);
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        return [];
      } else {
        result.forEach((product) {
          if (product['inputQuantity'] > 0) {
            products.add(ProductModel.fromJson(product));
          }
        });
      }
      return products;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<ProductModel>?> search(searchValue) async {
    final List<ProductModel> products = [];
    const String ipDevice = "10.0.2.2";
    final headers = {'Content-Type': 'application/json'};
    try {
      final url = Uri.parse("http://10.0.2.2:3000/product/search");
      final response = await http.post(url,
          headers: headers, body: json.encode({'searchValue': searchValue}));
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        return [];
      } else {
        result.forEach((product) {
          products.add(ProductModel.fromJson(product));
          if (product['inputQuantity'] > 0) {}
        });
      }
      return products;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
