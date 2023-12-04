import 'package:flutter/material.dart';
import 'package:photocopy/ui/auth/auth_manager.dart';
import 'package:photocopy/ui/cart/cart_manager.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/brand_manager.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';
import './screen_app.dart';
import './ui/auth/auth_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProvider(create: (ctx) => ProductManager()),
        ChangeNotifierProvider(create: (ctx) => AccessoryManager()),
        ChangeNotifierProvider(create: (ctx) => BrandManager()),
        ChangeNotifierProvider(create: (ctx) => CartManager()),
        ],
      child: Consumer<AuthManager>(builder: (ctx, authMangager, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: authMangager.isLogin ? const ScreenApp() : const AuthScreen(),
          routes: {AuthScreen.routerName: (context) => const AuthScreen()},
        );
      }),
    );
  }

  Widget returnPage(isLogin) {
    print('Thanh');
    final Widget page;
    if (isLogin) {
      page = const ScreenApp();
    } else {
      page = const AuthScreen();
    }
    print(page);
    return page;
  }
}
