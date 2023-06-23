import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vouch_tour_mobile/models/menu_model.dart';
import 'package:vouch_tour_mobile/pages/menu_pages/cart_page.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Menu> menus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    try {
      final fetchedMenus = await ApiService.fetchMenus();
      setState(() {
        menus = fetchedMenus;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching menus: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth * 0.1;

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : menus.isEmpty
              ? const Center(
                  child: Text('No menus available'),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          top: 16.0,
                        ),
                        child: Text(
                          'Menu Page',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: menus.length,
                          itemBuilder: (context, index) {
                            final menu = menus[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/images/tour_logo.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menu.title,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            const Text(
                                              'Quantity:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 4.0),
                                            Text(menu.quantity.toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: Colors.grey,
                                        onPressed: () {
                                          // Edit button logic
                                          // Add your code here
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          // Delete button logic
                                          // Add your code here
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProviderScope(
                child: CartPage(),
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
