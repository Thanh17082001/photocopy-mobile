import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:photocopy/model/cart_model.dart';

class CartService {
  Future<CartModel?> fetchAll(userId) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final CartModel cart;
      final url = Uri.parse("http://10.0.2.2:3000/cart/user/?userId=$userId");
      final response = await http.get(url, headers: headers);
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        return null;
      } else {
        if (result != null) {
          cart = CartModel.fromJson(result)!;
          return cart;
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<CartModel?> addCart(userId, product) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse("http://10.0.2.2:3000/cart/create");
      final response = await http.post(url,
          headers: headers,
          body: json.encode({'product': product, 'userId': userId}));
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        return null;
      } else {
        print(result['status']);
        if (result['status']) {
          final cart = CartModel.fromJson(result['result']);
          return cart;
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
