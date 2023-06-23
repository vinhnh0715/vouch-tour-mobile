import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vouch_tour_mobile/models/product_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: FutureBuilder<List<Product>>(
          future: ApiService.fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: Container(
                      width: 80,
                      height: 80,
                      child: CachedNetworkImage(
                        imageUrl: product.images[0].fileURL,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(product.productName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giá niêm yết: ${product.resellPrice} VND'),
                        Text('Nhà cung cấp: ${product.supplier.supplierName}'),
                        Text('Địa chỉ: ${product.supplier.address}'),
                        Text('Số điện thoại: ${product.supplier.phoneNumber}'),
                        Text('Phân loại: ${product.category.categoryName}'),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No products available'));
            }
          },
        ),
      ),
    );
  }
}
