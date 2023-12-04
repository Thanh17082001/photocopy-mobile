// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photocopy/model/product_model.dart';
import 'package:photocopy/ui/cart/cart_manager.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth_model.dart';

class HomeProduct extends StatefulWidget {
  const HomeProduct({super.key});

  @override
  State<HomeProduct> createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  Future getAllProduct(BuildContext context) async {
    if (typeProduct == 'product') {
      await context.read<ProductManager>().fetchproducts();
    } else {
      await context.read<AccessoryManager>().fetchproducts();
    }
  }

  String typeProduct = 'product';

  @override
  Widget build(BuildContext context) {
    final productManager = ProductManager();
    final accessoryManager = AccessoryManager();
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            typeProduct = 'product';
                          });
                          await getAllProduct(context);
                        },
                        child: Text(
                          'Máy',
                          style: TextStyle(
                              color: typeProduct == 'product'
                                  ? Colors.red
                                  : Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Text(
                        '|',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 27, 27),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            typeProduct = 'accessory';
                          });
                          await getAllProduct(context);
                        },
                        child: Text(
                          'Phụ kiện',
                          style: TextStyle(
                              color: typeProduct == 'accessory'
                                  ? Colors.red
                                  : Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 400,
          child: FutureBuilder(
              future: getAllProduct(context),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return typeProduct == 'product'
                    ? homepageGirdView(productManager)
                    : homepageGirdView2(accessoryManager);
              })),
        )
      ],
    );
  }

  Widget homepageGirdView(ProductManager productManager) {
    return Consumer<ProductManager>(builder: (ctx, productManager, child) {
      if (productManager.itemAcount == 0) {
        return const Center(child: Text("Không có sản phẩm"));
      } else {
        return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: productManager.itemAcount,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8.0)),
                child:
                    homepageGirdTite(productManager.products[index], context),
              );
            });
      }
    });
  }

  Widget homepageGirdView2(AccessoryManager productManager) {
    return Consumer<AccessoryManager>(builder: (ctx, productManager, child) {
      if (productManager.itemAcount == 0) {
        return const Center(child: Text("Không có sản phẩm"));
      } else {
        return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: productManager.itemAcount,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8.0)),
                child:
                    homepageGirdTite(productManager.products[index], context),
              );
            });
      }
    });
  }

  Widget homepageGirdTite(product, context) {
    return Column(
      children: [
        Image.network(
          'http://10.0.2.2:3000/${product.image}',
          height: 165.0,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 90.0,
            decoration: const BoxDecoration(
                color: Color(0xFF0E8388),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  product.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromARGB(255, 214, 214, 214)),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      curency(product.priceSale),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) =>
                                  ShowDialog(product: product)));
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ))
                  ],
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  String curency(price) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return currencyFormatter.format(price);
  }
}

class ShowDialog extends StatefulWidget {
  final product;
  const ShowDialog({Key? key, required this.product}) : super(key: key);

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  int quantity = 1;
  String validQuantity = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Hủy bỏ")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              var initUser = prefs.getString('user');
              if (initUser != null) {
                var user = AuthModel.fromJson(jsonDecode(initUser));
                var item = <String, dynamic>{};
                item['id'] = widget.product.id;
                item['typeProduct'] = widget.product?.typeProduct;
                item['quantityCart'] = quantity;
                if (user.id!.isEmpty) {
                  SnackBar(
                    content: const Text(
                        "Bạn hết thời gian đăng nhập vui lòng đăng nhập lại"),
                    action: SnackBarAction(
                      onPressed: () => print('aaaa'),
                      label: 'Đăng nhập',
                    ),
                  );
                } else {
                  if (validQuantity.isEmpty) {
                    // ignore: use_build_context_synchronously
                    var a = await context
                        .read<CartManager>()
                        .addCart(user.id, item);
                    if (a) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Đã thêm vào giỏ hàng',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                    } else {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Thêm không thành công thử lại',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                    }
                  }
                }
              }
              // Navigator.of(context).pop();
            },
            child: const Text("Thêm vào giỏ hàng"))
      ],
      title: Text(widget.product.name.toString()),
      content: SizedBox(
        height: 150.0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 30,
                child: Text('Giá bán: ${curency(widget.product.priceSale)}'),
              ),
              if (widget.product.priceRental != null)
                SizedBox(
                  height: 30,
                  child:
                      Text('Giá thuê: ${curency(widget.product.priceRental)}'),
                ),
              const SizedBox(
                height: 20.0,
                child: Text(
                  'Điều chỉnh số lượng',
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    IconButton(
                        iconSize: 20,
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                              validQuantity = "";
                            } else {
                              quantity--;
                              validQuantity = "Số lượng Phải lơn hơn không";
                            }
                          });
                        },
                        icon: const Icon(Icons.remove)),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        iconSize: 20,
                        onPressed: () {
                          setState(() {
                            if (quantity <
                                widget.product.inputQuantity!.toInt()) {
                              quantity++;
                              validQuantity = "";
                            } else {
                              quantity++;
                              validQuantity = "Số lượng trong kho không đủ";
                            }
                          });
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
              if (validQuantity.isNotEmpty)
                Text(
                  validQuantity,
                  style: const TextStyle(color: Colors.red, fontSize: 15),
                )
            ]),
      ),
    );
  }

  String curency(price) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return currencyFormatter.format(price);
  }
}
