import 'dart:convert';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;

class PanierService {
  final AuthProvider authProvider;
  PanierService({required this.authProvider});

  Future<Map<String, dynamic>> addItemToPanier(String menuItemID,
      String restaurantId, String quantity, List<String> supplements) async {
    final url =
        Uri.parse(ApiEndpoints.addItemToPanier); // Endpoint to add an item
    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(authProvider.token),
        body: jsonEncode({
          'menuItemID': menuItemID,
          'restaurantId': restaurantId,
          'quantity': quantity,
          'supplements': supplements,
        }),
      );
      // developer.log(response.body, name: 'body');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Item added to panier successfully'
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

  Future<List<dynamic>> fetchUserOrders() async {
    final url = Uri.parse(ApiEndpoints.getUserOrders);
    final response = await http.get(
      url,
      headers: _buildHeaders(authProvider.token),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['orders'];
    } else if (response.statusCode == 404) {
      throw Exception("No orders found for this user.");
    } else {
      throw Exception("Failed to fetch orders. Server error.");
    }
  }

  Future<List<dynamic>> fetchUserOrdersByRestaurant(String restaurantID) async {
    final url = Uri.parse(ApiEndpoints.getUserOrdersByRestaurant);
    final response = await http.post(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'restaurantID': restaurantID}),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['orders'];
    } else if (response.statusCode == 404) {
       throw Exception("No orders found for this Restaurant.");
    } else {
      throw Exception("Failed to fetch orders. Server error.");
    }
  }

// _____________ Total of Menuitem by (user && restaurant)_______________________
  Future<int> totalUserOrdersByRestaurant(String restaurantID) async {
    final url = Uri.parse(ApiEndpoints.totalUserOrdersByRestaurant);
    final response = await http.post(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'restaurantID': restaurantID}),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['number'] as int;
    } else if (response.statusCode == 404) {
      throw Exception("No orders found for this Restaurant.");
    } else {
      throw Exception("Failed to fetch orders. Server error.");
    }
  }

  Future<String> deleteItem(String panierItemID) async {
    final url = Uri.parse(ApiEndpoints.deleteItem);
    final response = await http.delete(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'panierItemID': panierItemID}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['message'];
    } else if (response.statusCode == 404) {
      throw Exception("No orders found for this user.");
    } else {
      throw Exception("Failed to fetch orders. Server error.");
    }
  }

  Future<String> updateQuantityItem(String itemId, int quantity) async {
    final url = Uri.parse(ApiEndpoints.updateItem);
    final response = await http.put(
      url,
      headers: _buildHeaders(authProvider.token),
      body: json.encode({'itemId': itemId, 'quantity': quantity}),
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
