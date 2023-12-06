import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photocopy/model/accessory_model.dart';
import 'package:photocopy/model/product_model.dart';
import 'package:photocopy/ui/cart/cart_manager.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final productInCart;
  const CartItem({super.key, this.productInCart});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.productInCart['typeProduct'] == 'product') {
      ProductModel product =
          context.read<ProductManager>().findById(widget.productInCart['id']);
      return bodyCart(product, context);
    } else {
      AccessoryModel product =
          context.read<AccessoryManager>().findById(widget.productInCart['id']);
      return bodyCart(product, context);
    }
  }

  Widget bodyCart(product, BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      background: Container(
        color: Colors.red[900],
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Xóa sản phẩm',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
            ]),
      ),
      // ignore: sort_child_properties_last
      child: Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Image.network('http://10.0.2.2:3000/${product.image}'),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name.toString().toUpperCase(),
                  style:
                      const TextStyle(color: Color(0xFF0E8388), fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text('Giá bán ${curency(product.priceSale)}'),
                if (widget.productInCart['typeProduct'] == 'product')
                  Text('Giá thuê/tháng ${curency(product.priceRental)}'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black45),
                  ),
                  width: 120,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          bool valid = await context
                              .read<CartManager>()
                              .changeQuantity(
                                  product.id, 'remove', product.inputQuantity);
                          if (!valid) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Số lượng không được bé hơn hoặc bằng không',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                          }
                        },
                        child: Container(
                            width: 40,
                            height: double.maxFinite,
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.black45, width: 1))),
                            child: const Icon(Icons.remove)),
                      ),
                      Text(widget.productInCart['quantityCart'].toString()),
                      GestureDetector(
                        onTap: () async {
                          bool valid = await context
                              .read<CartManager>()
                              .changeQuantity(
                                  product.id, 'add', product.inputQuantity);
                          if (!valid) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Số lượng trong kho không đủ',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                          }
                        },
                        child: Container(
                            width: 40,
                            height: double.maxFinite,
                            decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: Colors.black45, width: 1))),
                            child: const Icon(Icons.add)),
                      ),
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      ),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) => showConfirmDelete(context),
      onDismissed: (direction) async {
       await context.read<CartManager>().deleteProduct(product.id);
      },
    );
  }

  Future<bool?> showConfirmDelete(context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Bạn có muốn xóa sản phẩm'),
              content:
                  const Text('Hành động này sẽ xóa sản phẩm khỏi giỏ hàng'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text('Hủy bỏ')),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text('Tiếp tuc xóa')),
              ],
            ));
  }

  String curency(price) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return currencyFormatter.format(price);
  }
}
