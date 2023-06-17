import 'package:http/http.dart' as http;
import 'package:vouch_tour_mobile/models/cart_model.dart';
import 'dart:convert';
import 'package:vouch_tour_mobile/models/product_model.dart';
import 'package:vouch_tour_mobile/models/category_model.dart' as CategoryModel;
import 'package:vouch_tour_mobile/models/tour_guide_model.dart';

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
}
