import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:photocopy/model/order_model.dart';
import 'package:photocopy/ui/order/order_detail.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:photocopy/ui/order/order_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth_model.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  Future<void> getOrrderByUserId(BuildContext context) async {
    // ignore: use_build_context_synchronously
    await context.read<OrderManager>().getByUserId();
  }

  @override
  Widget build(BuildContext context) {
    final orderManager = OrderManager();
    return Column(
      children: [
        Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Lịch sử đơn hàng'.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ))),
        Expanded(
          child: FutureBuilder(
              future: getOrrderByUserId(context),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return listViewOrder(orderManager);
                }
              }),
        )
      ],
    );
  }

  Widget listViewOrder(orderManager) {
    return Consumer<OrderManager>(builder: (ctx, orderManager, index) {
      var a = orderManager.orders;
      // print(a[0].products![0]['productId']);
      // print(orderManager.orderCount);
      return ListView.builder(
          itemCount: orderManager.orderCount,
          itemBuilder: (context, index) {
            var product = a[index].products![0]['productId'];
            OrderModel order = orderManager.orders[index];
            return Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black38))),
              height: 140,
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                        "http://10.0.2.2:3000/${product['image']}"),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Text(
                            product['name'].toString().trimLeft().toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(curency(orderManager
                                      .orders[index].products![0]['priceSale'])
                                  .toString()),
                              Text(
                                  'x ${order.products![0]['quantity'].toString()}'),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ngày mua: ${(order.createdAt).toString()}',
                              style: const TextStyle(fontSize: 18),
                            )),
                        GestureDetector(
                          key: Key(order.id.toString()),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                OrderDetail.routerName,
                                arguments: order.id);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Xem chi tiết',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 17),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          });
    });
  }

  String curency(price) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return currencyFormatter.format(price);
  }
}
