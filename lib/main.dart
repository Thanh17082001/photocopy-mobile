import 'package:flutter/material.dart';
import 'package:photocopy/model/accessory_model.dart';
import 'package:photocopy/model/order_model.dart';
import 'package:photocopy/model/product_model.dart';
import 'package:photocopy/ui/auth/auth_manager.dart';
import 'package:photocopy/ui/cart/cart_manager.dart';
import 'package:photocopy/ui/cart/cart_screen.dart';
import 'package:photocopy/ui/order/order_detail.dart';
import 'package:photocopy/ui/order/order_manager.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/brand_manager.dart';
import 'package:photocopy/ui/order/order_screen.dart';
import 'package:photocopy/ui/product/product_detail_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => OrderManager()),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authMangager, child) {
        return MaterialApp(
          locale: const Locale('vi', 'VN'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: authMangager.isLogin ? const ScreenApp() : const AuthScreen(),
          routes: {
            AuthScreen.routerName: (context) => const AuthScreen(),
            CartScreen.routerName: (context) => const CartScreen(),
            OrderScreen.routerName: (context) => const OrderScreen(),
          },
          onGenerateRoute: ((settings) {
            if (settings.name == ProductDetai.routerName) {
              if (settings.arguments != null) {
                var arguments = settings.arguments as Map<String, dynamic>;
                if (arguments['typeProduct'] == 'product') {
                  return MaterialPageRoute(builder: (ctx) {
                    ProductModel product =
                        ctx.read<ProductManager>().findById(arguments['id']);
                    return ProductDetai(product);
                  });
                } else {
                  return MaterialPageRoute(builder: (ctx) {
                    AccessoryModel product =
                        ctx.read<AccessoryManager>().findById(arguments['id']);
                    return ProductDetai(product);
                  });
                }
              }
            } else if (settings.name == OrderDetail.routerName) {
              if (settings.arguments != null) {
                var id = settings.arguments as String;
                return MaterialPageRoute(builder: (ctx) {
                  OrderModel order = ctx.read<OrderManager>().findById(id);
                  return OrderDetail(order);
                });
              }
            }
          }),
        );
      }),
    );
  }

  Widget returnPage(isLogin) {
    final Widget page;
    if (isLogin) {
      page = const ScreenApp();
    } else {
      page = const AuthScreen();
    }
    return page;
  }
}
