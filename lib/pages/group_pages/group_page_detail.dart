import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouch_tour_mobile/models/group_model.dart';
import 'package:vouch_tour_mobile/models/product_menu_model.dart';
import 'package:vouch_tour_mobile/pages/group_pages/group_order_page.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

import 'generator_page.dart';

class GroupPageDetail extends StatefulWidget {
  final Group group;

  const GroupPageDetail({required this.group});

  @override
  _GroupPageDetailState createState() => _GroupPageDetailState();
}

class _GroupPageDetailState extends State<GroupPageDetail> {
  late Future<List<ProductMenu>> _productsInMenuFuture;

  @override
  void initState() {
    super.initState();
    _productsInMenuFuture = fetchProductsInMenu();
  }

  Future<List<ProductMenu>> fetchProductsInMenu() async {
    try {
      String? menuId = widget.group.menuId;
      final List<ProductMenu> productsInMenu =
          await ApiService.fetchProductsInMenu(menuId!);
      return productsInMenu;
    } catch (e) {
      // Handle error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin nhóm Tour"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tên nhóm: ${widget.group.groupName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8.0),
              Text('Mô tả nhóm: ${widget.group.description}'),
              Text('Số lượng thành viên: ${widget.group.quantity}'),
              Text(
                  'Ngày bắt đầu: ${dateFormat.format(widget.group.startDate)}'),
              Text('Ngày kết thúc: ${dateFormat.format(widget.group.endDate)}'),
              const Text('Trạng thái: In Progress'),
              const SizedBox(height: 16.0),
              const Text(
                'Menu dành cho nhóm:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<List<ProductMenu>>(
                future: _productsInMenuFuture,
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
                    final productsInMenu = snapshot.data ?? [];
                    if (productsInMenu.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: productsInMenu.length,
                        itemBuilder: (context, index) {
                          final productMenu = productsInMenu[index];
                          return ListTile(
                            leading: Container(
                              width: 80, // Set the desired width
                              height: 80, // Set the desired height
                              child: Image.network(
                                productMenu.images[0].fileURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(productMenu.productName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Mô tả sản phẩm: ${productMenu.description}'),
                                Text(
                                  'Giá: ${productMenu.actualPrice.toStringAsFixed(2)} VND',
                                ),
                                Text(
                                    'Nhà cung cấp: ${productMenu.supplierName}'),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text(
                        'Không có sản phẩm nào trong menu.',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                  }
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GenerateQrCodePage(groupId: widget.group.id!),
                    ),
                  );
                },
                child: Text('Show QR Code'),
              ),
              const SizedBox(
                height: 6.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GroupOrderPage(groupId: widget.group.id!),
                    ),
                  );
                },
                child: Text('View Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
