import 'package:vouch_tour_mobile/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void fetchProducts() async {
    try {
      final productsJson = await ApiService.fetchProducts();
      state = productsJson.cast<Product>();
    } catch (error) {
      // Handle error
    }
  }

  void isSelectItem(String productId, bool isSelected) {
    state = state.map((product) {
      if (product.id == productId) {
        return product.copyWith(isSelected: isSelected);
      } else {
        return product;
      }
    }).toList();
  }

  void incrementQty(String productId) {
    state = state.map((product) {
      if (product.id == productId) {
        return product.copyWith(qty: product.qty + 1);
      } else {
        return product;
      }
    }).toList();
  }

  void decreaseQty(String productId) {
    state = state.map((product) {
      if (product.id == productId) {
        return product.copyWith(qty: product.qty - 1);
      } else {
        return product;
      }
    }).toList();
  }
}

final proudctNotifierProvider =
    StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  final productNotifier = ProductNotifier();
  productNotifier
      .fetchProducts(); // Fetch the products when the provider is initialized
  return productNotifier;
});
