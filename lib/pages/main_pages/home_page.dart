import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vouch_tour_mobile/pages/main_pages/group_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/menu_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/order_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/profile_page.dart';
//import 'package:vouch_tour_mobile/utils/drawer.dart';
import 'package:vouch_tour_mobile/utils/footer.dart';

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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Hệ thống hỗ trợ TourGuide"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add your notification logic here
              },
            ),
          ],
        ),

        body: Column(
          children: [
            Expanded(
              child: PageView(
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
                  OrderPage(),
                  GroupPage(),
                  ProviderScope(
                    child: MenuPage(),
                  ),
                  const ProfilePage(),
                ],
              ),
            ),
          ],
        ),
        // drawer: AppDrawer(),
        bottomNavigationBar: AppFooter(
          currentIndex: _currentPageIndex,
          onTap: _navigateToPage,
          pageController: _pageController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
