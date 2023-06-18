import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:vouch_tour_mobile/models/cart_model.dart' as CartModel;

import '../../services/api_service.dart';

final cartItemsProvider = FutureProvider<List<CartModel.CartItem>>(
  (ref) => ApiService.fetchCartItems(),
);

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const Align(
            alignment: Alignment(0, 0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Giỏ hàng của bạn',
                style: TextStyle(
                  color: Color(0xff202020),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<List<CartModel.CartItem>>(
                future: ref.watch(cartItemsProvider.future),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final cartItems = snapshot.data ?? [];

                  return cartItems.isEmpty
                      ? const Center(child: Text('Cart is empty'))
                      : SizedBox(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Card(
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Image.network(
                                          item.images.isNotEmpty
                                              ? item.images[0].fileURL
                                              : '',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.productName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Gap(6),
                                              Text(
                                                item.description.length > 20
                                                    ? '${item.description.substring(0, 20)}...' // Truncate description if it exceeds 20 characters
                                                    : item.description,
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Gap(4),
                                              Text(
                                                '${item.actualPrice} VND',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Menu này được áp dụng coupon bởi:'),
                  const Gap(12),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFF843667),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              ApiService.currentUserId,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                  const Gap(12),
                  const Divider(),
                  Consumer(builder: (context, ref, _) {
                    final cartItemsAsyncValue = ref.watch(cartItemsProvider);

                    return cartItemsAsyncValue.when(
                      data: (cartItems) {
                        final totalPrice = _calculateTotalPrice(cartItems);
                        final totalItems = cartItems.length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng số lượng sản phẩm: $totalItems',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tổng giá trị giỏ hàng:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF843667),
                                  ),
                                ),
                                Text(
                                  '${totalPrice.toStringAsFixed(2)} VND',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF843667),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text(
                          'Your cart is empty, cant calculate total'),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalPrice(List<CartModel.CartItem>? cartItems) {
    if (cartItems == null) return 0.0;

    double totalPrice = 0.0;
    for (final item in cartItems) {
      totalPrice += item.actualPrice;
    }
    return totalPrice;
  }
}
