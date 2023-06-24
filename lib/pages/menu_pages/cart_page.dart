import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vouch_tour_mobile/models/cart_model.dart';
import 'package:vouch_tour_mobile/pages/product_pages/product_list_page.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

import 'components/continue_shopping_alert_dialog.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  bool isLoading = true;
  String currentCartId = '';
  TextEditingController menuTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final fetchedCartItems = await ApiService.fetchCartItems();
      final firstCartItem =
          fetchedCartItems.isNotEmpty ? fetchedCartItems[0] : null;
      if (firstCartItem != null) {
        currentCartId = firstCartItem.cartId;
      }
      setState(() {
        cartItems = fetchedCartItems;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (final cartItem in cartItems) {
      totalPrice += cartItem.actualPrice;
    }
    return totalPrice;
  }

  Future<void> createMenuAndClosePage() async {
    final title = menuTitleController.text;
    if (title.isEmpty) {
      // Show an error message if the menu title is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Hãy nhập tiêu đề cho menu!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final productMenus = cartItems
        .map((cartItem) => {
              'productId': cartItem.productId,
              'resellPrice': cartItem.actualPrice,
              'description': cartItem.description,
            })
        .toList();

    try {
      final statusCode = await ApiService.createMenu(title, productMenus);
      if (statusCode == 201 && productMenus.isNotEmpty) {
        // Menu created successfully
        // Clear cart
        await ApiService.deleteAllItemInCart(currentCartId);
        Navigator.pop(context); // Close the cart page
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Created Menu Successfully!',
        );
      } else if (productMenus.isEmpty) {
        // Menu created successfully
        Navigator.pop(context); // Close the cart page
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'You have created empty Menu!',
        );
      } else {
        // Show an error message if the API call was not successful
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Fail to create menu!',
        );
      }
    } catch (e) {
      // Show an error message if an exception occurred during the API call
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
      );
    }
  }

  Future<void> navigateToProductListPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProviderScope(
          child: ProductListPage(),
        ),
      ),
    );

    // Refresh the cart page after returning from the product list page
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang tạo Menu mới'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: menuTitleController,
                    decoration: InputDecoration(
                      labelText: "Nhập tiêu đề cho menu",
                      prefixIcon: Icon(
                        Icons.flag,
                        color: menuTitleController.text.isNotEmpty
                            ? Colors.lightBlueAccent
                            : Colors.blue,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 3,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 3,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.lightBlueAccent,
                          width: 3,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Update the icon color when the text changes
                        if (value.isNotEmpty) {
                          menuTitleController.text.isNotEmpty
                              ? Colors.lightBlueAccent
                              : Colors.grey;
                        }
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sản phẩm đã được thêm vào menu:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (cartItems.isEmpty)
                  const Center(
                    child: Text('Chưa có sản phẩm nào được thêm vào menu'),
                  )
                else
                  Expanded(
                    flex: 1,
                    child: Scrollbar(
                      thickness: 8.0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Container(
                              height:
                                  120, // Adjust the desired height for each item
                              child: Card(
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: double.infinity,
                                          child: Image.network(
                                            item.images.isNotEmpty
                                                ? item.images[0].fileURL
                                                : '',
                                            fit: BoxFit.cover,
                                          ),
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
                                                    ? '${item.description.substring(0, 20)}...'
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
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Xác nhận'),
                                              content: const Text(
                                                  'Bạn có chắc muốn xóa sản phẩm này khỏi menu?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context); // Close the dialog
                                                  },
                                                  child: const Text('Hủy'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(
                                                        context); // Close the dialog

                                                    try {
                                                      final item =
                                                          cartItems[index];
                                                      await ApiService
                                                          .deleteCartItem(
                                                              item.cartId,
                                                              item.id);

                                                      setState(() {
                                                        cartItems
                                                            .removeAt(index);
                                                      });
                                                    } catch (e) {
                                                      print(
                                                          'Error deleting item: $e');
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Xóa',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Tổng số lượng sản phẩm:   ${cartItems.length} sản phẩm',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Total giá trị menu:    ${getTotalPrice().toStringAsFixed(2)} VND',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Continue Shopping button logic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProviderScope(
                                  child: ProductListPage(),
                                ),
                              ),
                            ).then((value) {
                              fetchCartItems();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue, // Set the background color to blue
                          ),
                          child: const Text('Thêm sản phẩm'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialog(
                                title: 'Xác nhận',
                                description:
                                    'Tạo menu mới với những sản phẩm hiện tại?',
                                onContinuePressed: () async {
                                  await createMenuAndClosePage();
                                  fetchCartItems();
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Tạo Menu'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
