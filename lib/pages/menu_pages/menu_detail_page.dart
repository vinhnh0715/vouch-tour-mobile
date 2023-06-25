import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';
import 'package:vouch_tour_mobile/models/product_menu_model.dart';

class MenuDetailPage extends StatefulWidget {
  final String menuId;

  MenuDetailPage({required this.menuId});

  @override
  _MenuDetailPageState createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  List<ProductMenu> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await ApiService.fetchProductsInMenu(widget.menuId);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Detail'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: Image.network(
                    product.images.isNotEmpty ? product.images[0].fileURL : '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.description),
                      Text('Nhà cung cấp: ${product.supplierName}'),
                    ],
                  ),
                  trailing: Text(
                    '${product.actualPrice.toStringAsFixed(2)} VND',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
    );
  }
}
