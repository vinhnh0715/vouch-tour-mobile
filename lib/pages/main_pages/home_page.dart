import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vouch_tour_mobile/pages/main_pages/category_list_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/tour_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/profile_page.dart';
//import 'package:vouch_tour_mobile/utils/drawer.dart';
import 'package:vouch_tour_mobile/utils/footer.dart';
import 'package:vouch_tour_mobile/pages/main_pages/inventory_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/order_page.dart';

import '../product_pages/product_list_page.dart';

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Tour Assist System"),
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
            // SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: _currentPageIndex == 0
            //       ? Row(
            //           children: [
            //             Container(
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.circular(8),
            //                 border: Border.all(
            //                   color: Colors.black,
            //                   width: 1,
            //                 ),
            //               ),
            //               child: IconButton(
            //                 icon: Icon(Icons.qr_code),
            //                 onPressed: () {
            //                   // Add your QR code scanning logic here
            //                 },
            //               ),
            //             ),
            //             SizedBox(width: 10),
            //             Expanded(
            //               child: TextField(
            //                 decoration: InputDecoration(
            //                   hintText: 'Search',
            //                 ),
            //                 onChanged: (value) {
            //                   // Add your search logic here
            //                 },
            //               ),
            //             ),
            //             IconButton(
            //               icon: Icon(Icons.search),
            //               onPressed: () {
            //                 // Add your search logic here
            //               },
            //             ),
            //           ],
            //         )
            //       : null,
            // ),
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
                  //const OrderPage(),
                  CategoryListPage(),
                  const TourPage(),
                  //CategorySearchPage(),
                  const ProviderScope(
                    child: ProductListPage(),
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
