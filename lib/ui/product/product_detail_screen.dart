import 'package:flutter/material.dart';

class ProductDetai extends StatelessWidget {
  static const routerName = '/product-detail';
  // ignore: prefer_typing_uninitialized_variables
  final product;
  const ProductDetai(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    print(product.id);
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết sản phẩm')),
      body: Center(
        child: Text(product.id.toString()),
      ),
    );
  }
}
