import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouch_tour_mobile/models/order_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

import '../order_pages/order_detail_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ApiService.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo[500]!,
              Colors.indigo[100]!,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Tất cả đơn hàng',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<OrderModel>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        //'Error: ${snapshot.error}',
                        'Không có đơn hàng nào',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    final orders = snapshot.data ?? [];
                    if (orders.isNotEmpty) {
                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 4.0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailPage(orderId: order.id),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Mã đơn hàng: ${order.id}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tên khách hàng: ${order.customerName}'),
                                  Text('Số điện thoại: ${order.phoneNumber}'),
                                  Text(
                                      'Tổng giá tiền: ${order.totalPrice} VND'),
                                  Text(
                                    'Ngày đặt hàng: ${DateFormat('dd/MM/yyyy').format(order.creationDate)}',
                                  ),
                                  Text('Thuộc nhóm: ${order.groupName}'),
                                  Text('Trạng thái: ${order.status}'),
                                  Visibility(
                                    visible: order.status == "Waiting",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Handle Accept Order button tap
                                            await ApiService.updateOrder(
                                              order.id,
                                              "Completed",
                                            );
                                            setState(() {
                                              // Refresh the widget by rebuilding the widget tree
                                              _ordersFuture =
                                                  ApiService.fetchOrders();
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text('Nhận đơn'),
                                        ),
                                        const SizedBox(width: 36),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Handle Deny Order button tap
                                            await ApiService.updateOrder(
                                              order.id,
                                              "Canceled",
                                            );
                                            setState(() {
                                              // Refresh the widget by rebuilding the widget tree
                                              _ordersFuture =
                                                  ApiService.fetchOrders();
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text('Hủy đơn'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Không có đơn hàng nào!',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
