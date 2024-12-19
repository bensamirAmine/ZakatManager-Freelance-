import 'dart:convert';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

// ignore: camel_case_types
class commandeService {
  final AuthProvider authProvider;
  commandeService({required this.authProvider});

  Future<Map<String, dynamic>> setCommande(
      String restaurantId,
      List<dynamic> panierItems,
      double latitude,
      double longitude,
      String deliveryAddress,
      String paymentMethod,
      int totalProductAmount,
      double totalAmount) async {
    final url = Uri.parse(ApiEndpoints.setCommande);
    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(authProvider.token),
        body: jsonEncode({
          'restaurantID': restaurantId,
          'panierItems': panierItems,
          'latitude': latitude,
          'longitude': longitude,
          'deliveryAddress': deliveryAddress,
          'paymentMethod': paymentMethod,
          'totalProductAmount': totalProductAmount,
          'totalAmount': totalAmount,
        }),
      );
      developer.log("Request Body: $response.body",
          name: 'commandeService.setCommande');
      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseBody['message'],
        };
      } else {
        final responseBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Error adding item to panier'
        };
      }
    } catch (error) {
      return {'success': false, 'message': 'Server error: $error'};
    }
  }

  Future<Map<String, dynamic>>  getOrdersDetails(String orderID) async {
    final url = Uri.parse(ApiEndpoints.getOderDetails);
    final response = await http.post(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'orderID': orderID}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['order'];
    } else if (response.statusCode == 404) {
      throw Exception("Commande introuvable .");
    } else {
      throw Exception("Failed to fetch orders. Server error.");
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
