import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photocopy/ui/cart/cart_item.dart';
import 'package:photocopy/ui/order/order_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth_model.dart';
import 'cart_manager.dart';

class CartScreen extends StatefulWidget {
  static const routerName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final carts = context.read<CartManager>().products;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: const Color(0xFF0E8388),
      ),
      body: Column(children: [Expanded(child: itemsCart())]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26, width: 0.5)),
            color: Colors.white24),
        width: double.infinity,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<CartManager>(builder: (context, cartManager, index) {
              return Text(
                  'Tổng giá: ${curency(context.read<CartManager>().totalProduct())}');
            }),
            Consumer<CartManager>(builder: (context, cartManager, index) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      elevation: 3.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40)),
                  // ignore: unnecessary_null_comparison
                  onPressed: (cartManager.productCount > 0)
                      ? () async {
                          // ignore: use_build_context_synchronously
                          await Navigator.of(context)
                              .pushNamed(OrderScreen.routerName, arguments: {
                            'products': carts,
                            'total': cartManager.totalProduct(),
                          });
                        }
                      : null,
                  child: const Text('Mua hàng'));
            })
          ],
        ),
      ),
    );
  }

  Widget itemsCart() {
    return Consumer<CartManager>(builder: (context, cartManager, index) {
      if (cartManager.productCount > 0) {
        return ListView.builder(
          itemCount: cartManager.productCount,
          itemBuilder: (context, index) {
            return CartItem(productInCart: cartManager.products[index]);
          },
        );
      } else {
        return const Center(
          child: Text('Chưa có sản phẩm trong giỏ hàng'),
        );
      }
    });
  }

  String curency(price) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return currencyFormatter.format(price);
  }
}
