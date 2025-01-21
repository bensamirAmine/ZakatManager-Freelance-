import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupplementService {
  final AuthProvider authProvider;
  SupplementService({required this.authProvider});

  Future<List<dynamic>> getALlSupplements() async {
    try {
      final token = authProvider.token;
      final response = await http.get(
        Uri.parse(ApiEndpoints.getAllSupplement),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Menu not found');
      } else {
        throw Exception('Failed to load Supplements details');
      }
    } catch (error) {
      throw Exception('Failed to load Supplements details');
    }
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
