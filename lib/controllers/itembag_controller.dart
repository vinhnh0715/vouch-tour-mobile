import 'package:vouch_tour_mobile/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<Product> itemBag = [];

class ItemBagNotifier extends StateNotifier<List<Product>> {
  ItemBagNotifier() : super(itemBag);

  // Add new item

  void addNewItemBag(Product productModel) {
    state = [...state, productModel];
  }

  // Remove item

  void removeItem(String productId) {
    state = state.where((product) => product.id != productId).toList();
  }
}

final itemBagProvider =
    StateNotifierProvider<ItemBagNotifier, List<Product>>((ref) {
  return ItemBagNotifier();
});

final priceCalcProvider = Provider<double>((ref) {
  final itemBag = ref.watch(itemBagProvider);

  double sum = 0;
  for (var element in itemBag) {
    sum += element.resellPrice;
  }
  return sum;
});
