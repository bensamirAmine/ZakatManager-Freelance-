import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/MenuItem.dart';

import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/LivreurService.dart';

import 'package:provider/provider.dart';

class LivreurProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _message;
  List<dynamic> _nearbyorders = [];

  List<dynamic> get nearbyOrders => _nearbyorders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get message => _message;
  Future<void> updateItem(BuildContext context, double latitude,
      double longitude, double radius) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final livreurService = LivreurService(authProvider: authProvider);
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _message = await livreurService.setCurrentLocationforDelivery(
          latitude, longitude);
      fetchNearbyOrders(context, radius);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNearbyOrders(BuildContext context, double radius) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final livreurService = LivreurService(authProvider: authProvider);

    _setLoadingState(true);

    try {
      _nearbyorders = await livreurService.fetchNearbyOrders(radius);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
