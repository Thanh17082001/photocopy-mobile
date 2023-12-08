import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photocopy/model/order_model.dart';

class OrderDetail extends StatelessWidget {
  static const routerName = '/order-detail';
  final OrderModel order;
  const OrderDetail(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    final products = order.products;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        backgroundColor: const Color(0xFF0E8388),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 50,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Thông tin khách hàng',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  )),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Tên Khách hàng: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            order.nameCustomer.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Số điện thoại: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            order.phone.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Địa chỉ: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            order.address.toString().trimLeft(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            Container(
              height: 20,
              width: double.infinity,
              color: const Color.fromARGB(26, 95, 95, 95),
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
            const SizedBox(
              width: double.infinity,
              height: 50,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Thông tin đơn hàng',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  )),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Mã đơn hàng: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            order.id.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Ngày mua: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            order.createdAt.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Trạng thái đơn hàng: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            order.status.toString().trimLeft(),
                            style:
                                const TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            Container(
              height: 20,
              width: double.infinity,
              color: const Color.fromARGB(26, 95, 95, 95),
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
            const SizedBox(
              width: double.infinity,
              height: 50,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Danh sách sản phẩm',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              height: 290,
              child: ListView.builder(
                itemCount: products!.length,
                itemBuilder: (ctx, index) {
                  var productItem = products[index]['productId'];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                              "http://10.0.2.2:3000/${productItem['image']}"),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                child: Text(
                                  productItem['name']
                                      .toString()
                                      .trimLeft()
                                      .toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(curency(products[index]['priceSale'])
                                        .toString()),
                                    Text(
                                        'x ${products[index]['quantity'].toString()}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 90,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Row(
                  children: [
                    const Text('Tổng tiền sản phẩm:'),
                    Text(curency(order.totalCostOfProducts).toString()),
                  ],
                ),
                Row(
                  children: [
                    const Text('Phí vận chuyển 1%:'),
                    Text(curency((order.totalCostOfProducts! * 0.01).toInt())),
                  ],
                ),
                Row(
                  children: [
                    const Text('Tổng cộng:'),
                    Text(curency(order.totalAmount).toString()),
                  ],
                ),
              ]),
            )
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
}
