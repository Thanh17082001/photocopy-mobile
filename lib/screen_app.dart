import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:photocopy/ui/auth/auth_manager.dart';
import 'package:photocopy/ui/auth/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './model/auth_model.dart';

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
  List pages = ['Trang chủ', 'Sản phẩm', 'Tin tức', 'Giỏ hàng'];
  

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
        actions: [logout()],
      ),
      bottomNavigationBar: navBotomBar(),
      body: Text(pages[selectedIndex]),
    );
  }

  Widget navBotomBar() {
    return CurvedNavigationBar(
        height: 65.0,
        backgroundColor: Colors.white30,
        color: Colors.red,
        onTap: changePage,
        items: const [
          Icon(
            Icons.home,
            color: Colors.black87,
          ),
          Icon(
            Icons.shop,
            color: Colors.black87,
          ),
          Icon(
            Icons.new_label,
            color: Colors.black87,
          ),
          Icon(
            Icons.payment,
            color: Colors.black87,
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
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(AuthScreen.routerName);
          context.read<AuthManager>().logout();
        },
        icon: const Icon(Icons.logout));
  }

  // ignore: non_constant_identifier_names
  Widget userInfo(user) {
    return Row(
      children: [
         CircleAvatar(
          backgroundImage:  NetworkImage('http://10.0.2.2:3000${user.avatar}'),
        ),
         const SizedBox(
          width: 15,
        ),
        Text(user.fullName),
       
      ],
    );
  }
}
