import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouch_tour_mobile/models/order_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class GroupOrderPage extends StatefulWidget {
  final String groupId;

  const GroupOrderPage({required this.groupId});

  @override
  _GroupOrderPageState createState() => _GroupOrderPageState();
}

class _GroupOrderPageState extends State<GroupOrderPage> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ApiService.fetchOrdersByGroupId(widget.groupId);
  }

  Future<List<OrderModel>> fetchOrdersByGroupId() async {
    try {
      final List<OrderModel> orders =
          await ApiService.fetchOrdersByGroupId(widget.groupId);
      return orders;
    } catch (e) {
      // Handle error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của nhóm'),
      ),
      body: FutureBuilder<List<OrderModel>>(
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
                'Nhóm không có đơn hàng nào',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final orders = snapshot.data ?? [];
            if (orders.isNotEmpty) {
              return ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: ListTile(
                              title: Text(
                                'Mã đơn hàng: ${order.id}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Tên khách hàng: ${order.customerName}'),
                                    Text('Số điện thoại: ${order.phoneNumber}'),
                                    Text(
                                        'Tổng giá tiền: ${order.totalPrice} VND'),
                                    Text(
                                      'Ngày đặt hàng: ${DateFormat('dd/MM/yyyy').format(order.creationDate)}',
                                    ),
                                    Text('Trạng thái: ${order.status}'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle Accept Order button tap
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text('Nhận đơn'),
                                        ),
                                        const SizedBox(width: 36),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle Deny Order button tap
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text('Hủy đơn'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'Nhóm không có đơn hàng nào!',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
