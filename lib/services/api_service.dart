import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vouch_tour_mobile/models/product_model.dart';

class ApiService {
  static const String baseUrl =
      'https://vouch-tour-apis.azurewebsites.net/api/';
  static String jwtToken = '';
  static String currentEmail = '';

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
  static Future<List<Category>> fetchCategories() async {
    String jwtToken =
        ApiService.jwtToken; // Get the JWT token from the ApiService
    if (jwtToken.isEmpty) {
      jwtToken = await ApiService.fetchJwtToken(
          ApiService.currentEmail); // Fetch the JWT token if it's empty
    }

    final url = Uri.parse('${baseUrl}categorys');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = json.decode(response.body);
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}
