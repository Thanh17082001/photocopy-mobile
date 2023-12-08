// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:photocopy/ui/auth/auth_manager.dart';
import 'package:photocopy/ui/auth/auth_screen.dart';
import 'package:photocopy/ui/cart/cart_manager.dart';
import 'package:photocopy/ui/cart/cart_screen.dart';
import 'package:photocopy/ui/order/order_history.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './model/auth_model.dart';
import 'package:photocopy/ui/site/home_screen.dart';

import 'ui/cart/cart_icon.dart';

class ScreenApp extends StatefulWidget {
  const ScreenApp({super.key});

  @override
  State<ScreenApp> createState() => _ScreenAppState();
}

class _ScreenAppState extends State<ScreenApp> {
  int selectedIndex = 0;
  bool? isLogin;
  // ignore: prefer_typing_uninitialized_variables
  AuthModel? user;
  List<Widget> pages = [const HomeScreen(), const OrderHistory()];

  Future<AuthModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    if (initUser != null) {
      user = AuthModel.fromJson(jsonDecode(initUser));
      return user;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E8388),
        title: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final myObject = snapshot.data;
              if (myObject != null) {
                return userInfo(myObject);
              } else {
                return const Text('No object found in SharedPreferences.');
              }
            }
          },
        ),
        actions: [
          cartButton(),
          const SizedBox(
            width: 8,
          ),
          logout()
        ],
      ),
      bottomNavigationBar: navBotomBar(),
      body: pages[selectedIndex],
    );
  }

  Widget navBotomBar() {
    return CurvedNavigationBar(
        height: 65.0,
        backgroundColor: Colors.white30,
        color: const Color.fromARGB(255, 255, 44, 44),
        onTap: changePage,
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.shop,
            color: Colors.white,
          ),
          Icon(
            Icons.new_label,
            color: Colors.white,
          ),
          Icon(
            Icons.payment,
            color: Colors.white,
          ),
          // Icon(
          //   Icons.admin_panel_settings_sharp,
          //   color: Colors.black87,
          // ),
        ]);
  }

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget logout() {
    return IconButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('user');
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   AuthScreen.routerName,
          //   (route) => false,
          // );
          context.read<AuthManager>().logout();
        },
        icon: const Icon(Icons.logout));
  }

  // ignore: non_constant_identifier_names
  Widget userInfo(user) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('http://10.0.2.2:3000${user.avatar}'),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(user.fullName),
      ],
    );
  }

  Future<void> getCart() async {
    await context.read<CartManager>().getCartByUserId();
  }

  Future<void> products() async {
    await context.read<ProductManager>().fetchproducts();
  }

  Widget cartButton() {
    getCart();
    return Consumer<CartManager>(builder: (context, cartManager, index) {
      return CartIcon(
        count: cartManager.productCount,
        child: GestureDetector(
          child: const Icon(
            Icons.shopping_cart,
            size: 35,
          ),
          onTap: () async {
            await getCart();
            await context.read<ProductManager>().fetchproducts();
            await context.read<AccessoryManager>().fetchproducts();
            context.read<CartManager>().totalProduct();
            Navigator.of(context).pushNamed(CartScreen.routerName);
          },
        ),
      );
    });
  }
}
