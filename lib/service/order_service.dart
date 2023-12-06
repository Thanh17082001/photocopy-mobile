import 'dart:convert';
import '../model/order_model.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<bool> addOrder(
      products, customer, createBy, totalCostOfProducts) async {
    const String ipDevice = "10.0.2.2";
    final url = Uri.parse("http://$ipDevice:3000/order/create");
    final url2 = Uri.parse("http://$ipDevice:3000/customer/create");
    final headers = {'Content-Type': 'application/json'};
    try {
      final response2 =
          await http.post(url2, headers: headers, body: json.encode(customer));
      final result2 = json.decode(response2.body);
      print(result2['result']['_id']);
      if (response2.statusCode != 200) {
        return false;
      } else {
        var order = {
          'createBy': createBy,
          'customerId': result2['result']['_id'],
          'products': products['products'],
          'totalCostOfProducts': totalCostOfProducts,
          'totalAmount': totalCostOfProducts * 0.01 + totalCostOfProducts,
          'IsOnlineOrder': true,
          'transportFee': totalCostOfProducts * 0.01
        };
        final response =
            await http.post(url, headers: headers, body: json.encode(order));
        if (response.statusCode != 200) {
          return false;
        } else {
          return true;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
