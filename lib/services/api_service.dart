import 'package:http/http.dart' as http;
import 'package:vouch_tour_mobile/models/cart_model.dart';
import 'package:vouch_tour_mobile/models/group_model.dart';
import 'package:vouch_tour_mobile/models/menu_model.dart';
import 'dart:convert';
import 'package:vouch_tour_mobile/models/product_model.dart';
import 'package:vouch_tour_mobile/models/product_menu_model.dart';
import 'package:vouch_tour_mobile/models/category_model.dart' as CategoryModel;
import 'package:vouch_tour_mobile/models/tour_guide_model.dart';

import '../models/order_model.dart';

class ApiService {
  static const String baseUrl =
      'https://vouch-tour-apis.azurewebsites.net/api/';
  static String jwtToken = '';
  static String currentEmail = '';
  static String currentUserId = '';

  // ========================= AUTHENTICATION API ==============================
  static Future<String> fetchJwtToken(String email) async {
    final url = Uri.parse('${baseUrl}authentication');
    final body = jsonEncode({
      'eMail': email,
    });

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      jwtToken = data['accessToken'];
      currentEmail = email;
      currentUserId = data['id'];
      return jwtToken;
    } else if (response.statusCode == 401) {
      // Access token expired, try refreshing the token using the refresh token
      final refreshToken = json.decode(response.body)['refreshToken'];
      final refreshResponse = await http.post(
        Uri.parse('${baseUrl}authentication/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (refreshResponse.statusCode == 200) {
        final refreshData = json.decode(refreshResponse.body);
        jwtToken = refreshData['accessToken'];
        currentEmail = email;
        return jwtToken;
      } else {
        throw Exception('Failed to refresh JWT token');
      }
    } else {
      throw Exception('Failed to fetch JWT token');
    }
  }

  // ========================= PRODUCTS API ==============================
  static Future<List<Product>> fetchProducts() async {
    String jwtToken =
        ApiService.jwtToken; // Get the JWT token from the ApiService
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(
          ApiService.currentEmail); // Fetch the JWT token if it's empty
    }

    final url = Uri.parse('${baseUrl}products');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  static Future<List<Product>> fetchProductsByCategoryId(
      String categoryId) async {
    String jwtToken =
        ApiService.jwtToken; // Get the JWT token from the ApiService
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(
          ApiService.currentEmail); // Fetch the JWT token if it's empty
    }

    final url = Uri.parse('${baseUrl}categories/$categoryId/products');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products by category ID');
    }
  }

  // ========================= CATEGORY API ==============================
  static Future<List<CategoryModel.Category>> fetchCategories() async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('$baseUrl/categories');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = json.decode(response.body);
      final List<CategoryModel.Category> categories = categoriesJson
          .map((json) => CategoryModel.Category.fromJson(json))
          .toList();

      return categories;
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  // ========================= TOURGUIDE API ==============================
  static Future<TourGuide> fetchTourGuide(String id) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('$baseUrl/tour-guides/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> tourGuideJson = json.decode(response.body);
      return TourGuide.fromJson(tourGuideJson);
    } else {
      throw Exception('Failed to fetch tour guide');
    }
  }

  // ========================= CART API ==============================
  //get all item in cart
  static Future<List<CartItem>> fetchCartItems() async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}carts');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> cartItemsJson = json.decode(response.body);
      return cartItemsJson.map((json) => CartItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cart items');
    }
  }

  // add item to cart
  static Future<int> addToCart(String productId, double actualPrice) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}carts');
    final body = jsonEncode({
      'productId': productId,
      'actualPrice': actualPrice,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: body,
    );

    return response.statusCode;
  }

  //delete item in cart
  static Future<void> deleteCartItem(String cartId, String itemId) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}carts/$cartId/items/$itemId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      print('Item deleted successfully');
    } else {
      throw Exception('Failed to delete item from the cart');
    }
  }

  //delete item in cart
  static Future<void> deleteAllItemInCart(String cartId) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}carts/$cartId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      print('Clear items in cart successfully');
    } else {
      throw Exception('Failed to clear items in the cart');
    }
  }

  // ========================= GROUPS API ==============================
  static Future<List<Group>> fetchGroups() async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}groups');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> groupsJson = json.decode(response.body);
      return groupsJson.map((json) => Group.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch groups');
    }
  }

  // Create group
  static Future<void> createGroup(Group group) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}groups');
    final body = jsonEncode(group.toJson());

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: body,
    );
  }

  // Get group by ID
  static Future<Group> getGroupById(String id) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}groups/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> groupJson = json.decode(response.body);
      return Group.fromJson(groupJson);
    } else {
      throw Exception('Failed to fetch group');
    }
  }

  // Update group
  static Future<void> updateGroup(Group group) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}groups');
    final body = jsonEncode(group.toJson());

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: body,
    );

    if (response.statusCode == 204) {
      print('Group updated successfully');
    } else if (response.statusCode == 401) {
      // Handle token expiration or invalid token error
      throw Exception('Unauthorized request');
    } else {
      throw Exception(
          'Failed to update group. Status code: ${response.statusCode} and ${response.body}');
    }
  }

  // ========================= MENU API ==============================
  // Get all Menu of tourguide
  static Future<List<Menu>> fetchMenus() async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}menus');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> menusJson = json.decode(response.body);
      return menusJson.map((json) => Menu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch menus');
    }
  }

  // create menu
  static Future<int> createMenu(
      String title, List<Map<String, dynamic>> productMenus) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}menus');
    final body = jsonEncode({
      'title': title,
      'productMenus': productMenus,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: body,
    );

    return response.statusCode;
  }

  // delete menu by id
  static Future<void> deleteMenu(String menuId) async {
    final url = Uri.parse('${baseUrl}menus/$menuId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      print('Menu deleted successfully');
    } else if (response.statusCode == 401) {
      // Handle token expiration or invalid token error
      throw Exception('Unauthorized request');
    } else {
      throw Exception('Failed to delete menu');
    }
  }

  // Get all products in a menu
  static Future<List<ProductMenu>> fetchProductsInMenu(String menuId) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}menus/$menuId/products-menu');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => ProductMenu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products in menu');
    }
  }

  // ========================= TOURGUIDE API ==============================
  // get all orders in group by group id
  static Future<List<OrderModel>> fetchOrdersByGroupId(String groupId) async {
    String jwtToken = ApiService.jwtToken;
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(ApiService.currentEmail);
    }

    final url = Uri.parse('${baseUrl}groups/$groupId/orders');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = json.decode(response.body);
      return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders by group ID');
    }
  }
}
