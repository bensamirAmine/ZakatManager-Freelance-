import 'package:foodly_ui/A-models/Restaurant.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final AuthProvider authProvider;
  UserService({required this.authProvider});

  Future<Map<String, dynamic>> getUser() async {
    // developer.log(jsonEncode(authProvider.token), name: 'Authorization');
    final token = authProvider.token;
    final response = await http.get(
      Uri.parse(ApiEndpoints.profile),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Map<String, dynamic>> likerestaurant(String restaurantId) async {
    final url = Uri.parse(ApiEndpoints.likerestaurant);

    try {
      final token = authProvider.token;

      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode({'restaurantId': restaurantId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        developer.log(jsonEncode(responseBody), name: 'responseBody');
        return {
          'message': responseBody['message'],
        };
      } else if (response.statusCode == 404) {
        return {
          'status': false,
          'error': 'User does not exist',
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

  Future<Map<String, dynamic>> dislikerestaurant(String restaurantId) async {
    final url = Uri.parse(ApiEndpoints.likerestaurant);

    try {
      final token = authProvider.token;

      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode({'restaurantId': restaurantId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          'message': responseBody['message'],
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

  Future<Map<String, dynamic>> likeMenu(String menuId) async {
    final url = Uri.parse(ApiEndpoints.likeMenu);

    try {
      final token = authProvider.token;

      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode({'menuId': menuId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        developer.log(jsonEncode(responseBody), name: 'responseBody');
        return {
          'message': responseBody['message'],
          'rating': responseBody['rating'],
        };
      } else if (response.statusCode == 404) {
        return {
          'status': false,
          'error': 'User does not exist',
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

  Future<Map<String, dynamic>> dislikemenu(String menuId) async {
    final url = Uri.parse(ApiEndpoints.DislikeMenu);

    try {
      final token = authProvider.token;

      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode({'menuId': menuId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          'message': responseBody['message'],
          'rating': responseBody['rating'],
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
