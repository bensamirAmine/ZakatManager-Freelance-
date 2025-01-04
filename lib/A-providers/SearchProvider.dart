import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/Restaurant.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/RestaurantService.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class SearchProvider with ChangeNotifier {
  List<dynamic> _allRestaurants = [];
  List<dynamic> _filteredRestaurants = [];
  bool _isLoading = false;

  List<dynamic> get filteredRestaurants => _filteredRestaurants;
  bool get isLoading => _isLoading;

  // Charger tous les restaurants
  Future<void> fetchRestaurants(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _allRestaurants =
        await RestaurantService(authProvider: authProvider).fetchRestaurants();
    developer.log("Response: ${(_allRestaurants)}", name: 'service check ');
    _isLoading = false;
    notifyListeners();
  }

  void filterRestaurants(String query) {
    if (query.isEmpty) {
      _filteredRestaurants = _allRestaurants;
      developer.log("filtered: ${(_filteredRestaurants)}",
          name: 'service check ');
      _isLoading = false;
    } else {
      _filteredRestaurants = _allRestaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
