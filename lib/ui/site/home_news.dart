import 'package:flutter/material.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeNews extends StatelessWidget {
  const HomeNews({super.key});
  Future getAllProduct(BuildContext context) async {
    await context.read<ProductManager>().fetchproducts();
  }

  @override
  Widget build(BuildContext context) {
    final productManager = ProductManager();
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sản phẩm ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
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
        FutureBuilder(
            future: getAllProduct(context),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return homepageGirdView(productManager);
            }))
      ],
    );
  }

  Widget homepageGirdView(ProductManager productManager) {
    return Consumer<ProductManager>(builder: (ctx, productManager, child) {
      if (productManager.itemAcount == 0) {
        return const Center(child: Text("Không có sản phẩm"));
      } else {
        return SizedBox(
          height: 300.0,
          child: GridView.builder(
              itemCount:
                  productManager.itemAcount > 8 ? 8 : productManager.itemAcount,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1,
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
              }),
        );
      }
    });
  }

  Widget homepageGirdTite(product, context) {
    return Column(
      children: [
        Image.network(
          'http://10.0.2.2:3000/${product.image}',
          height: 180.0,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            height: 75.0,
            decoration: const BoxDecoration(
                color: Color(0xFF0E8388),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            width: double.maxFinite,
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white
                  ),
                ),
                Expanded(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(curency(product.priceSale), style: const TextStyle(
                    color: Color.fromARGB(255, 53, 255, 3)
                  ),),
                  
                    IconButton(
                        onPressed: () {
                          print('aaa');
                        },
                        icon: const Icon(Icons.shopping_cart, color: Colors.white,))
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
  String curency(price){
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'vnd');
    return currencyFormatter.format(price); 
  }
}
