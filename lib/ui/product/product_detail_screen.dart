import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photocopy/model/brand_model.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/brand_manager.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';

import '../cart/cart_icon.dart';
import '../cart/cart_manager.dart';
import '../cart/cart_screen.dart';
import '../site/home_product.dart';

class ProductDetai extends StatefulWidget {
  static const routerName = '/product-detail';
  // ignore: prefer_typing_uninitialized_variables
  final product;
  const ProductDetai(this.product, {super.key});

  @override
  State<ProductDetai> createState() => _ProductDetaiState();
}

class _ProductDetaiState extends State<ProductDetai> {
  @override
  Widget build(BuildContext context) {
    BrandModel brandModel =
        context.read<BrandManager>().findById(widget.product.brandId);
    print(brandModel.name);
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm'),
        backgroundColor: const Color(0xFF0E8388),
        actions: [cartButton(), const SizedBox(width: 20,)],
        ),
      body: ListView(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.network(
              'http://10.0.2.2:3000/${widget.product.image}',
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 80,
            child: Text(
              widget.product.name.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(color: Color(0xFF0E8388), fontSize: 20),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black45, width: 1))),
            height: 30,
            width: double.infinity,
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Thông tin sản phẩm',
                    style: TextStyle(color: Colors.red))),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Thương hiệu: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        brandModel.name.toString().toUpperCase(),
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Giá bán: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        curency(widget.product.priceSale),
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  if (widget.product.priceRental != null)
                    Row(
                      children: [
                        const Text(
                          'Giá bán:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          curency(widget.product.priceRental),
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    )
                ],
              )),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black45, width: 1))),
            height: 30,
            width: double.infinity,
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(color: Colors.red),
                )),
          ),
          Container(
            height: 200,
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: SingleChildScrollView(
              child: Text(
                widget.product.description.toString(),
                style: const TextStyle(
                    color: Color.fromARGB(255, 64, 64, 64),
                    fontSize: 18,
                    height: 1.25),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      elevation: 1.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20)),
                  // ignore: unnecessary_null_comparison
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) =>
                            ShowDialogClass(product: widget.product)));
                  },
                  child: const Text('Thêm vào giỏ hàng')),
            ],
          )),
        
    );
  }

  String curency(price) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return currencyFormatter.format(price);
  }

  Future<void> getCart() async {
    await context.read<CartManager>().getCartByUserId();
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
            // ignore: use_build_context_synchronously
            await context.read<ProductManager>().fetchproducts();
            // ignore: use_build_context_synchronously
            await context.read<AccessoryManager>().fetchproducts();
            // ignore: use_build_context_synchronously
            context.read<CartManager>().totalProduct();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamed(CartScreen.routerName);
          },
        ),
      );
    });
  }
}
