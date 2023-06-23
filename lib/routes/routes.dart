import 'package:vouch_tour_mobile/pages/backup_pages/cart_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/home_page.dart';
import 'package:vouch_tour_mobile/pages/backup_pages/inventory_page.dart';
import 'package:vouch_tour_mobile/pages/login_page.dart';
import 'package:vouch_tour_mobile/pages/notification_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/order_page.dart';
import 'package:vouch_tour_mobile/pages/main_pages/profile_page.dart';
import 'package:vouch_tour_mobile/pages/backup_pages/tour_page.dart';
import 'package:vouch_tour_mobile/pages/backup_pages/category_list_page.dart';
import 'package:vouch_tour_mobile/pages/product_pages/list_product_by_category_id.dart';

var appRoutes = {
  "/": (context) => LoginPage(),
  "/home": (context) => HomePage(),
  "/login": (context) => LoginPage(),
  "/inventory": (context) => InventoryPage(),
  "/order": (context) => OrderPage(),
  "/notification": (context) => NotificationPage(),
  "/profile": (context) => ProfilePage(),
  "/createnewtour": (context) => TourPage(),
  "/categorylist": (context) => CategoryListPage(),
  "/cartpage": (context) => CartPage(),
  //"/listproductbycategoryid": (context) => ListProductByCategoryId(),
};
