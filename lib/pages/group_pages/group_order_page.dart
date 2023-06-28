import 'package:flutter/material.dart';
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
        title: const Text('Orders in Group'),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            );
          } else {
            final orders = snapshot.data ?? [];
            if (orders.isNotEmpty) {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text('Order ID: ${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Price: ${order.totalPrice}'),
                        Text('Status: ${order.status}'),
                        Text('Customer Name: ${order.customerName}'),
                      ],
                    ),
                    onTap: () {
                      // Handle order tap
                    },
                  );
                },
              );
            } else {
              return const Text(
                'No orders found.',
                style: TextStyle(color: Colors.red),
              );
            }
          }
        },
      ),
    );
  }
}
