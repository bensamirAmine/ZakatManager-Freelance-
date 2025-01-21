import 'dart:convert';
import 'package:foodly_ui/A-models/Transaction.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class ZakatService {
  final AuthProvider authProvider;
  ZakatService({required this.authProvider});
  Future<Map<String, dynamic>> AddTransaction(String type, String category,
      double amount, String acquisitionDate) async {
    final url = Uri.parse(ApiEndpoints.setTransaction);
    try {
      final response = await http.put(
        url,
        headers: _buildHeaders(authProvider.token),
        body: jsonEncode({
          'type': type,
          'category': category,
          'amount': amount,
          'acquisitionDate': acquisitionDate,
        }),
      );
      developer.log(response.body, name: 'body');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        return {
          'message': responseBody['message'] ?? 'Error adding transaction',
          // 'zakatAmount': responseBody['zakatAmount'],
          // 'balance': responseBody['balance'],
          // 'goldWeight': responseBody['goldWeight'],
        };
      } else {
        final responseBody = jsonDecode(response.body);
        return {
          'message': responseBody['message'] ?? 'Error adding transaction'
        };
      }
    } catch (error) {
      return {'success': false, 'message': 'Server error: $error'};
    }
  }

  Future<UserTotals> recalculateTotals() async {
    final url = Uri.parse(ApiEndpoints.getHistorique);
    final response = await http.get(
      url,
      headers: _buildHeaders(authProvider.token),
    );

    if (response.statusCode == 200) {
      return UserTotals.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to recalculate totals');
    }
  }

  Future<String> deleteTransaction(String transactionID) async {
    final url = Uri.parse(ApiEndpoints.delete_transaction);
    final response = await http.post(
      url,
      headers: _buildHeaders(authProvider.token),
      body: jsonEncode({
        'transactionID': transactionID,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['message'];
    } else {
      throw Exception("Failed to fetch orders. Server error.");
    }
  }

  Future<String> updateTransaction(String transactionID, double amount) async {
    final url = Uri.parse(ApiEndpoints.updateTransaction);
    final response = await http.post(
      url,
      headers: _buildHeaders(authProvider.token),
      body: jsonEncode({'transactionID': transactionID, 'amount': amount}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['message'];
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
