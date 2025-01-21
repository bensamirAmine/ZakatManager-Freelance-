import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/Commande.dart';
import 'package:foodly_ui/A-models/MenuItem.dart';

import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/PanierService.dart';
import 'package:foodly_ui/A-services/commandeService.dart';
import 'dart:developer' as developer;

import 'package:provider/provider.dart';

class CommandeProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _message;
  Map<String, dynamic>? _commande;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get message => _message;
  Map<String, dynamic>? get commande => _commande;

  Future<void> setCommande(
      BuildContext context,
      String restaurantId,
      List<dynamic> panierItems,
      double latitude,
      double longitude,
      String deliveryAddress,
      String paymentMethod,
      int totalProductAmount,
      double totalAmount) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cmdService = commandeService(authProvider: authProvider);
    _setLoadingState(true);

    try {
      final response = await cmdService.setCommande(
          restaurantId,
          panierItems,
          latitude,
          longitude,
          deliveryAddress,
          paymentMethod,
          totalProductAmount,
          totalAmount);
      _message = response['message'];

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> getOrdersDetails(BuildContext context, String orderID) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cmdService = commandeService(authProvider: authProvider);

    _setLoadingState(true);

    try {
      _commande = await cmdService.getOrdersDetails(orderID);
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
}
