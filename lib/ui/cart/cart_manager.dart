import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:photocopy/model/cart_model.dart';
import 'package:photocopy/service/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth_model.dart';

class CartManager with ChangeNotifier {
  final CartService cartService = CartService();
  CartModel _items = CartModel();
  List? get products {
    return _items.products;
  }

  int get productCount {
    return _items.products?.length ?? 0;
  }

  Future getCartByUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    var user = AuthModel.fromJson(jsonDecode(initUser!));
    var value = (await cartService.fetchAll(user.id));
    if(value!= null){
      _items = (await cartService.fetchAll(user.id))!;
    }
    notifyListeners();
  }

  Future<bool> addCart(userId, product) async {
    var a = await cartService.addCart(userId, product);
    // ignore: unnecessary_null_comparison
    if (a != null) {
      _items = a;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }
}
