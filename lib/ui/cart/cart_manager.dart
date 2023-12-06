import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:photocopy/model/accessory_model.dart';
import 'package:photocopy/model/cart_model.dart';
import 'package:photocopy/model/product_model.dart';
import 'package:photocopy/service/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../product/product_manager.dart';
import '../product/accessory_manager.dart';
import '../../model/auth_model.dart';

class CartManager with ChangeNotifier {
  final ProductManager productManager = ProductManager();
  final AccessoryManager accessoryManager = AccessoryManager();
  final CartService cartService = CartService();
  CartModel _items = CartModel();
  List get products {
    return _items.products ?? [];
  }

  int get productCount {
    return _items.products?.length ?? 0;
  }

  Future getCartByUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    var user = AuthModel.fromJson(jsonDecode(initUser!));
    var value = (await cartService.fetchAll(user.id));
    if (value != null) {
      _items = (await cartService.fetchAll(user.id))!;
    } else {
      _items = CartModel();
    }
    totalProduct();
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

  int indexProduct(id) {
    if (products.isNotEmpty) {
      int a = products.indexWhere((element) => element['id'] == id);
      return a;
    } else {
      return -1;
    }
  }

  Future<bool> changeQuantity(id, type, quantity) async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    var user = AuthModel.fromJson(jsonDecode(initUser!));
    int index = indexProduct(id);
    if (products.isNotEmpty) {
      if (products[index] != null) {
        if (type == 'add') {
          if (products[index]['quantityCart'] > quantity) {
            return false;
          }
          products[index]['quantityCart'] += 1;
          notifyListeners();
        } else {
          if (products[index]['quantityCart'] <= 1) {
            return false;
          }
          products[index]['quantityCart'] -= 1;
          notifyListeners();
        }
      }
      bool res = await cartService.updateQuantity(user.id, products);
      if (res) {
        await getCartByUserId();
        totalProduct;
        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  deleteProduct(id) async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    var user = AuthModel.fromJson(jsonDecode(initUser!));
    int index = indexProduct(id);
    if (products.isNotEmpty) {
      if (products[index] != null) {
        products.removeAt(index);
        await cartService.updateQuantity(user.id, products);
        await getCartByUserId();
        notifyListeners();
      }
    }
    totalProduct;
    notifyListeners();
  }

  int totalProduct() {
    int total = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    products.forEach((item) async {
      if (item['typeProduct'] == 'product') {
        ProductModel product = productManager.findById(item['id']);
        if (product.priceSale != null) {
          total += (product.priceSale! * item['quantityCart']) as int;
        }
      } else {
        AccessoryModel accessory = accessoryManager.findById(item['id']);
        if (accessory.priceSale != null) {
          total += (accessory.priceSale! * item['quantityCart']) as int;
        }
      }
    });
    return total;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    var initUser = prefs.getString('user');
    var user = AuthModel.fromJson(jsonDecode(initUser!));
    _items.products = [];
    await cartService.updateQuantity(user.id, []);
    notifyListeners();
  }
}
