import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:photocopy/model/order_model.dart';
import 'package:photocopy/service/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/accessory_model.dart';
import '../../model/auth_model.dart';
import '../../model/product_model.dart';
import '../product/accessory_manager.dart';
import '../product/product_manager.dart';

class OrderManager with ChangeNotifier {
  OrderService orderService = OrderService();
  final ProductManager productManager = ProductManager();
  final AccessoryManager accessoryManager = AccessoryManager();
  List<OrderModel> _items = [];

  Future<bool> addOrder(data, customer, total) async {
    await productManager.fetchproducts();
    await accessoryManager.fetchproducts();
    data['products'].forEach((item) async {
      item['productId'] = item['id'];
      item['quantity'] = item['quantityCart'];
      if (item['typeProduct'] == 'product') {
        ProductModel product = productManager.findById(item['id']);
        if (product.name != null) {
          item['nameProduct'] = product.name;
          item['warrantyTime'] = product.warrantyTime;
          item['priceSale'] = product.priceSale;
          item['priceImport'] = product.priceImport;
        }
      } else {
        AccessoryModel accessory = accessoryManager.findById(item['id']);
        if (accessory.name != null) {
          item['nameProduct'] = accessory.name;
          item['priceSale'] = accessory.priceSale;
          item['priceImport'] = accessory.priceImport;
        }
      }
    });
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    var user = AuthModel.fromJson(jsonDecode(initUser!));
    bool res = await orderService.addOrder(data, customer, user.id, total);
    return res;
  }

  List<OrderModel> get orders {
    return [..._items];
  }

  int get orderCount {
    return _items.length;
  }

  Future<void> getByUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    var user = AuthModel.fromJson(jsonDecode(initUser!));
    _items = (await orderService.getByUserId(user.id.toString()))!;
    notifyListeners();
  }
  OrderModel findById(String id) {
    getByUserId();
    if (_items.isNotEmpty) {
      return _items.firstWhere((product) => product.id == id);
    } else {
      return OrderModel();
    }
  }
}
