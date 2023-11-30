import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/accessory_model.dart';

class AccessoryService {
  Future<List<AccessoryModel>?> getAll() async {
    final List<AccessoryModel> products = [];
    const String ipDevice = "10.0.2.2";
    try {
      final url = Uri.parse("http://$ipDevice:3000/accessory/");
      final response = await http.get(url);
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        return [];
      } else {
        result.forEach((product) {
          if (product['inputQuantity'] > 0) {
            products.add(AccessoryModel.fromJson(product));
          }
        });
      }
      return products;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<AccessoryModel>?> getByBrandId(brandId) async {
    final List<AccessoryModel> products = [];
    const String ipDevice = "10.0.2.2";
    try {
      final url = Uri.parse(
          "http://$ipDevice:3000/accessory/filter/?field=brandId&type=$brandId");
      final response = await http.get(url);
      final result = json.decode(response.body);
      
      print(result);
      if (response.statusCode != 200) {
        return [];
      } else {
        result.forEach((product) {
          if (product['inputQuantity'] > 0) {
            products.add(AccessoryModel.fromJson(product));
          }
        });
      }
      return products;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
