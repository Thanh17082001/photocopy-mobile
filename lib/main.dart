import 'package:flutter/material.dart';
import 'package:photocopy/ui/auth/auth_manager.dart';
import 'package:provider/provider.dart';
import './screen_app.dart';
import './ui/auth/auth_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager())
      ],
      child: Consumer<AuthManager>(builder: (ctx, authMangager, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: authMangager.isLogin ? const ScreenApp() :const AuthScreen() ,
            routes: {
              AuthScreen.routerName:(context) => const AuthScreen()
            },
          );
        }
      ),
    );
  }
}



