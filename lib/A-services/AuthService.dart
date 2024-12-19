import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/Restaurant.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/entry_point.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiEndpoints.userlogin);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        saveToken(token);
        return {
          'status': responseBody['status'],
          'token': responseBody['token'],
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

  // Helper method to build headers with token
  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };
    // if (token != null) {
    //   headers['Authorization'] = 'Bearer $token';
    // }
    return headers;
  }
}
