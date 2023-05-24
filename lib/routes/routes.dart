import 'package:vouch_tour_mobile/pages/home_page.dart';
import 'package:vouch_tour_mobile/pages/inventory_page.dart';
import 'package:vouch_tour_mobile/pages/login_page.dart';
import 'package:vouch_tour_mobile/pages/notification_page.dart';
import 'package:vouch_tour_mobile/pages/order_page.dart';

var appRoutes = {
  "/": (context) => LoginPage(),
  "/home": (context) => HomePage(),
  "/login": (context) => LoginPage(),
  "/inventory": (context) => InventoryPage(),
  "/order": (context) => OrderPage(),
  "/notification": (context) => NotificationPage(),
};
