import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:vouch_tour_mobile/models/cart_model.dart';
import 'package:vouch_tour_mobile/pages/product_pages/product_list_page.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  bool isLoading = true;
  TextEditingController menuTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final fetchedCartItems = await ApiService.fetchCartItems();
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
            content: const Text('Please enter a menu title.'),
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
      if (statusCode == 201) {
        // Menu created successfully
        Navigator.pop(context); // Close the cart page
      } else {
        // Show an error message if the API call was not successful
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to create the menu.'),
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
      }
    } catch (e) {
      // Show an error message if an exception occurred during the API call
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred while creating the menu.'),
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
    }
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
                if (cartItems.isEmpty)
                  const Center(
                    child: Text('Chưa có sản phẩm nào được thêm vào menu'),
                  )
                else
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
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Thêm sản phẩm vào menu:',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          height:
                              100, // Adjust the desired height for each item
                          child: Card(
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
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
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total Items: ${cartItems.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Total Price: \$${getTotalPrice().toStringAsFixed(2)}',
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
                          onPressed: () {
                            // Continue Shopping button logic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProviderScope(
                                  child: ProductListPage(),
                                ),
                              ),
                            );
                          },
                          child: const Text('Continue Shopping'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            createMenuAndClosePage();
                          },
                          child: const Text('Confirm Cart'),
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
