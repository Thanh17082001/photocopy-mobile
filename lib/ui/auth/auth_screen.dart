import 'package:flutter/material.dart';
import './auth_banner.dart';
import './auth_form.dart';
class AuthScreen extends StatelessWidget {
  static const routerName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              AuthBanner(),
              SizedBox(
                height: 15,
              ),
              AuthForm()
            ]
            ),
        ),
      ),
    );
  }
}