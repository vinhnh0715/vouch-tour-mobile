import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/pages/home_page.dart';
import 'package:vouch_tour_mobile/pages/inventory_page.dart';
import 'package:vouch_tour_mobile/pages/order_page.dart';
import 'package:vouch_tour_mobile/pages/notification_page.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final PageController pageController; // Add pageController parameter

  const AppFooter({
    required this.currentIndex,
    required this.onTap,
    required this.pageController, // Update the constructor
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      currentIndex: currentIndex,
      onTap: (int index) {
        onTap(index); // Call the provided onTap callback

        // Animate the page view to the selected page
        pageController.animateToPage(
          // Access pageController from the parameter
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Đơn hàng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: 'Thêm tour mới',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Sản phẩm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
