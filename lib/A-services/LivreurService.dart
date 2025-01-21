import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LivreurService {
  final AuthProvider authProvider;
  LivreurService({required this.authProvider});

  Future<Map<String, dynamic>> livreurLogin(
      String email, String password) async {
    final url = Uri.parse(ApiEndpoints.livreurlogin);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          'status': responseBody['status'],
          'token': responseBody['token'],
          'message': responseBody['message'],
          'user': responseBody['user']
        };
      } else if (response.statusCode == 404) {
        return {
          'status': false,
          'error': 'User does not exist',
        };
      } else if (response.statusCode == 401) {
        return {
          'status': false,
          'error': 'Invalid password',
        };
      } else {
        return {
          'status': false,
          'error': 'Unknown error occurred',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'error': 'Failed to login: $e',
      };
    }
  }

  Future<String> setCurrentLocationforDelivery(
      double latitude, double longitude) async {
    final url = Uri.parse(ApiEndpoints.setCurrentLocationforDelivery);
    final response = await http.put(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'latitude': latitude, 'longitude': longitude}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['message'];
    } else if (response.statusCode == 404) {
      throw Exception("No orders found for this user.");
    } else {
      throw Exception("Failed to update this order. Server error.");
    }
  }

  Future<List<dynamic>> fetchNearbyOrders(double radius) async {
    final url = Uri.parse(ApiEndpoints.getnearbyOrders);
    final response = await http.post(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'radius': radius}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['nearbyOrders'];
    } else if (response.statusCode == 404) {
      throw Exception("Pas de commande dans ce secteur .");
    } else {
      throw Exception("Failed to fetch orders. Server error.");
    }
  }

  // Save token using SharedPreferences
  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Retrieve the token
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String> getRestaurantIdbypanierItem(String panierId) async {
    final url = Uri.parse(ApiEndpoints.get_restID_by_panier_item);
    final response = await http.post(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'panierId': panierId}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['restaurantId'];
    } else if (response.statusCode == 404) {
      throw Exception("No orders found for this user.");
    } else {
      throw Exception("Failed to update this order. Server error.");
    }
  }

  Map<String, String> _buildHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['token'] = 'Bearer $token';
    }
    return headers;
  }
}
