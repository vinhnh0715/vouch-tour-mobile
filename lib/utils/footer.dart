import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final PageController pageController;

  const AppFooter({
    required this.currentIndex,
    required this.onTap,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFF3F3F3),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, 'Trang chủ', 0, context),
            _buildBottomNavItem(Icons.shopping_cart, 'Giỏ hàng', 1, context),
            _buildBottomNavItem(
                Icons.book_outlined, 'Quản lý tour', 2, context),
            _buildBottomNavItem(Icons.inventory, 'Sản phẩm', 3, context),
            _buildBottomNavItem(
                Icons.account_circle_outlined, 'Tài khoản', 4, context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
      IconData icon, String label, int index, BuildContext context) {
    final color = currentIndex == index ? Colors.blue : Colors.black;
    final themeData = Theme.of(context);
    final labelStyle = themeData.textTheme.caption?.copyWith(color: color);

    return InkWell(
      onTap: () {
        onTap(index);
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: labelStyle),
        ],
      ),
    );
  }
}
