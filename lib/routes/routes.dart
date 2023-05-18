import 'package:vouch_tour_mobile/pages/home_page.dart';
import 'package:vouch_tour_mobile/pages/login_page.dart';

var appRoutes = {
  "/": (context) => LoginPage(),
  "/home": (context) => HomePage(),
  "/login": (context) => LoginPage(),
};
