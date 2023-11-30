import 'package:flutter/material.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    final productManager =  ProductManager();
    final accessoryManager =  AccessoryManager();
    return Expanded(
      child: Column(
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
                  GestureDetector(
                      onTap: () {
                        print('aaaa');
                      },
                      child: const Text(
                        "Xem Thêm",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ))
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
                  return typeProduct =='product' ? homepageGirdView(productManager) : homepageGirdView2(accessoryManager);
                })),
          )
        ],
      ),
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
                          print('aaa');
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
        NumberFormat.currency(locale: 'vi_VN', symbol: 'vnd');
    return currencyFormatter.format(price);
  }
}
