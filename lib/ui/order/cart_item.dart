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
    return Container(
      width: double.infinity,
      height: 100,
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
            children: [
              Text(
                product.name.toString().toUpperCase(),
                style:
                    const TextStyle(color: Color(0xFF0E8388), fontSize: 18),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text('Giá bán ${curency(product.priceSale)}'),
                  Text('x ${widget.productInCart['quantityCart']}'),
                ],
              ),
            ],
          ))
        ],
      ),
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
