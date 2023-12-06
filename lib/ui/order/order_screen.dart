import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photocopy/ui/cart/cart_screen.dart';
import 'package:photocopy/ui/order/order_manager.dart';
import 'package:photocopy/ui/site/home_product.dart';
import 'package:provider/provider.dart';

import '../order/cart_item.dart';
import '../cart/cart_manager.dart';

class OrderScreen extends StatefulWidget {
  static const routerName = '/order';
  // ignore: prefer_typing_uninitialized_variables
  final products;
  // ignore: prefer_typing_uninitialized_variables
  final total;
  const OrderScreen({super.key, this.products, this.total});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _isSubmitting = ValueNotifier<bool>(false);
  final Map<String, String> _customer = {
    'email': '',
    'address': '',
    'phone': '',
    'fullName': ''
  };

  @override
  Widget build(BuildContext context) {
    final total = context.read<CartManager>().totalProduct();
    final count = context.read<CartManager>().productCount;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt hàng'),
        backgroundColor: const Color(0xFF0E8388),
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10, top: 8),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black38, width: 0.5))),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Danh sách $count sản phẩm ',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 100, child: itemsCart()),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10, top: 8),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black38, width: 0.5),
            )),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Chi tiết thanh toán',
              style: TextStyle(fontSize: 20),
            ),
          ),
          detailPay(total),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10, top: 8),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black38, width: 0.5),
            )),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Thông tin khách hàng',
              style: TextStyle(fontSize: 20),
            ),
          ),
          formOrder()
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26, width: 0.5)),
            color: Colors.white24),
        width: double.infinity,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<CartManager>(builder: (context, cartManager, index) {
              return Text(
                  'Tổng giá: ${curency(context.read<CartManager>().totalProduct())}');
            }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    elevation: 3.0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40)),
                // ignore: unnecessary_null_comparison
                onPressed: () async {
                  var result = await submitOrder(total);
                  if (result) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                        context: context,
                        builder: (
                          ctx,
                        ) {
                          return AlertDialog(
                            actions: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black54,
                                      backgroundColor: const Color.fromARGB(
                                          255, 231, 237, 230)),
                                  onPressed: () async {
                                    await context.read<CartManager>().clear();
                                    // ignore: use_build_context_synchronously
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  child: const Text("Quay lại trang chủ")),
                            ],
                            title: const Text('Mua hàng thành công'),
                            content: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 79, 244,
                                      54), // Màu sắc của đường viền
                                  width: 4.0, // Độ dày của đường viền
                                ), // Màu sắc của hình tròn
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Color.fromARGB(255, 79, 244,
                                      54), // Màu sắc của biểu tượng check
                                  size: 50.0, // Kích thước của biểu tượng check
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
                child: const Text('Đặt hàng'))
          ],
        ),
      ),
    );
  }

  String curency(price) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return currencyFormatter.format(price);
  }

  Widget itemsCart() {
    return Consumer<CartManager>(builder: (context, cartManager, index) {
      if (cartManager.productCount > 0) {
        return ListView.builder(
          itemCount: cartManager.productCount,
          itemBuilder: (context, index) {
            return CartItem(productInCart: cartManager.products[index]);
          },
        );
      } else {
        return const Center(
          child: Text('Chưa có sản phẩm trong giỏ hàng'),
        );
      }
    });
  }

  Widget formOrder() {
    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _fullNameField(),
            const SizedBox(
              height: 15,
            ),
            _phoneField(),
            const SizedBox(
              height: 15,
            ),
            _emailField(),
            const SizedBox(
              height: 15,
            ),
            _addressField()
          ],
        ),
      ),
    );
  }

  Widget _fullNameField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập tên của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Tên không được bỏ trống';
        }
        return null;
      },
      onSaved: (value) {
        _customer['fullName'] = value!;
      },
    );
  }

  Widget _phoneField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập số điện thoại của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'SĐT không hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _customer['phone'] = value!;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập email của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Email không hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _customer['email'] = value!;
      },
    );
  }

  Widget _addressField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập địa chỉ của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Địa chỉ không hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _customer['address'] = value!;
      },
    );
  }

  Widget detailPay(total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng tiền hàng:'),
            Text(curency(total)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Phí vận chuyển'),
            if (total != null) Text(curency((total! * 0.01).toInt())),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng cộng'),
            if (total != null) Text(curency((total! + total! * 0.01).toInt())),
          ],
        )
      ]),
    );
  }

  Future<bool> submitOrder(total) async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    _formKey.currentState!.save();
    _isSubmitting.value = true;
    var products = context.read<CartManager>().products;
    var data = {'products': products};
    bool a =
        await context.read<OrderManager>().addOrder(data, _customer, total);
    return a;
  }
}
