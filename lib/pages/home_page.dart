import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/utils/drawer.dart';
import 'package:vouch_tour_mobile/utils/footer.dart';
import 'package:vouch_tour_mobile/pages/inventory_page.dart';
import 'package:vouch_tour_mobile/pages/order_page.dart';
import 'package:vouch_tour_mobile/pages/notification_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  void _navigateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vouch Tour App"),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          Center(
            child: Container(
              child: Text("Hello world! This is home page."),
            ),
          ),
          InventoryPage(),
          OrderPage(),
          NotificationPage(),
        ],
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: AppFooter(
        currentIndex: _currentPageIndex,
        onTap: _navigateToPage,
        pageController: _pageController,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
