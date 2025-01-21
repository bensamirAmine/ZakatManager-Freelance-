import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/MenuItem.dart';

import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/PanierService.dart';
import 'dart:developer' as developer;

import 'package:provider/provider.dart';

class PanierProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  MenuItem? _menuItem;
  String? _message;
  String? _message2;
  String? _message3;

  List<dynamic> _orders = [];
  // ignore: non_constant_identifier_names
  List<dynamic> _orders_by_restaurant = [];
  // ignore: non_constant_identifier_names
  int? _item_panier_number = 0;
  List<dynamic> get orders => _orders;
  List<dynamic> get ordersbyrestaurant => _orders_by_restaurant;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get message => _message;
  String? get messageD => _message2;
  String? get messageU => _message3;

  MenuItem? get menu => _menuItem;
  int? get paniernbr => _item_panier_number;

  Future<void> addItemToPanier(BuildContext context, String id,
      String restaurantId, String quantity, List<String> supplements) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final panierService = PanierService(authProvider: authProvider);
    _setLoadingState(true);

    try {
      final response = await panierService.addItemToPanier(
          id, restaurantId, quantity, supplements);
      _message = response['message'];
      // Réactualiser les commandes pour ce restaurant après l'ajout
      await fetchUserOrdersByRestaurant(context, restaurantId);
      notifyListeners();

      developer.log(_message!, name: '_message');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserOrders(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final panierService = PanierService(authProvider: authProvider);

    _setLoadingState(true);

    try {
      _orders = await panierService.fetchUserOrders();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserOrdersByRestaurant(
      BuildContext context, String restaurantID) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final panierService = PanierService(authProvider: authProvider);

    _setLoadingState(true);

    try {
      _orders_by_restaurant =
          await panierService.fetchUserOrdersByRestaurant(restaurantID);
      _item_panier_number = _orders_by_restaurant.length;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> totalUserOrdersByRestaurant(
      BuildContext context, String restaurantID) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final panierService = PanierService(authProvider: authProvider);

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _item_panier_number =
          await panierService.totalUserOrdersByRestaurant(restaurantID);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteItem(
      BuildContext context, String panierItemID, String restaurantId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final panierService = PanierService(authProvider: authProvider);

    _setLoadingState(true);

    try {
      _message2 = await panierService.deleteItem(panierItemID);
      await fetchUserOrders(context);
      await fetchUserOrdersByRestaurant(context, restaurantId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// marwen@gmail.com
  Future<void> updateItem(
      BuildContext context, String panierItemID, int quantity) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final panierService = PanierService(authProvider: authProvider);
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _message3 =
          await panierService.updateQuantityItem(panierItemID, quantity);
      _orders = await panierService.fetchUserOrders();
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
