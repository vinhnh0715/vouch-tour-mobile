import 'package:vouch_tour_mobile/pages/main_pages/home_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/inventory_page.dart';
import 'package:vouch_tour_mobile/pages/login_page.dart';
import 'package:vouch_tour_mobile/pages/notification_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/order_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/profile_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/tour_page.dart';

var appRoutes = {
  "/": (context) => LoginPage(),
  "/home": (context) => HomePage(),
  "/login": (context) => LoginPage(),
  "/inventory": (context) => InventoryPage(),
  "/order": (context) => OrderPage(),
  "/notification": (context) => NotificationPage(),
  "/profile": (context) => ProfilePage(),
  "/createnewtour": (context) => TourPage(),
};
