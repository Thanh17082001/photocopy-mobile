import 'package:flutter/material.dart';
import 'package:photocopy/ui/site/home_brand.dart';
import 'package:photocopy/ui/site/home_product.dart';
import 'package:photocopy/ui/site/home_search.dart';
import '../site/home_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: const <Widget>[
        HomeSearch(),
        // HomeBanner(),
        HomeBrand(),
        HomeProduct()
      ],
    );
  }
}
