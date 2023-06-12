import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart'; // Import the package

import 'package:vouch_tour_mobile/models/product_model.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
        Uri.parse('https://vouch-tour-apis.azurewebsites.net/api/Products'));

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: FutureBuilder<List<Product>>(
          future: fetchProducts(),
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
