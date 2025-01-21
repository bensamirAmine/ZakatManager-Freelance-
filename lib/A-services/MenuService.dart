import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class MenuService {
  final AuthProvider authProvider;
  MenuService({required this.authProvider});

  Future<Map<String, dynamic>> getMenuById(String menuId) async {
    try {
      final token = authProvider.token;
      final response = await http.post(
        Uri.parse(ApiEndpoints.fetchMenuDetails),
        headers: _buildHeaders(token),
        body: json.encode({'menuId': menuId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        throw Exception('Menu not found');
      } else {
        throw Exception('Failed to load Menu details');
      }
    } catch (error) {
      throw Exception('Failed to load Menu details');
    }
  }

  Future<Map<String, dynamic>> checkUserLike(String menuId) async {
    final Uri url = Uri.parse(ApiEndpoints.checkUserLikeMenu);
    final token = authProvider.token;

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode({'menuId': menuId}),
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
    headers['token'] = 'Bearer $token';
  }
  return headers;
}
