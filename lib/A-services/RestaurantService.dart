import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class RestaurantService {
  final AuthProvider authProvider;
  // final String token;
  RestaurantService({required this.authProvider});

  Future<List<dynamic>> fetchRestaurants() async {
    // developer.log(jsonEncode(authProvider.token), name: 'Authorization');
    final token = authProvider.token;
    final response = await http.get(
      Uri.parse(ApiEndpoints.fetchRestaurants),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<List<dynamic>> searchRestaurant() async {
    // developer.log(jsonEncode(authProvider.token), name: 'Authorization');
    final token = authProvider.token;
    final response = await http.get(
      Uri.parse(ApiEndpoints.fetchRestaurants),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
  Future<Map<String, dynamic>> getRestaurantById(String restaurantId) async {
    try {
      final token = authProvider.token;
      final response = await http.post(
        Uri.parse(ApiEndpoints.restaurantDetails),
        headers: _buildHeaders(token),
        body: json.encode({'restaurantId': restaurantId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        throw Exception('Restaurant not found');
      } else {
        throw Exception('Failed to load restaurant details');
      }
    } catch (error) {
      throw Exception('Failed to load restaurant details');
    }
  }

  Future<Map<String, dynamic>> checkUserLike(String restaurantId) async {
    final Uri url = Uri.parse(ApiEndpoints.checkUserLike);
    final token = authProvider.token;

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode({'restaurantId': restaurantId}),
      );

      if (response.statusCode == 200 || response.statusCode == 404) {
        developer.log("Response: ${jsonEncode(response.body)}",
            name: 'service check ');

        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to check like status');
      }
    } catch (error) {
      throw Exception('Error checking user like: $error');
    }
  }
}

Map<String, String> _buildHeaders(String? token) {
  final headers = {
    'Content-Type': 'application/json',
  };
  if (token != null) {
    headers['token'] =
        'Bearer $token'; // Use 'Authorization' for standard practice
  }
  return headers;
}
