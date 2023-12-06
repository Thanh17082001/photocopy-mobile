import 'dart:convert';

import 'package:flutter/foundation.dart';
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
  Future<bool> addOrder(data, customer, total) async {
    await productManager.fetchproducts();
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

 
}
