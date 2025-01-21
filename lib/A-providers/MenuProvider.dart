import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/MenuItem.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/MenuService.dart';
import 'dart:developer' as developer;

import 'package:provider/provider.dart';

class MenuProvider with ChangeNotifier {

  bool _isLoading = false;
  String? _errorMessage;
  MenuItem? _menuItem;
  String? _message;
 
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get message => _message;
  MenuItem? get menu => _menuItem;

  Future<void> getMenuById(BuildContext context, String id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final restaurantService = MenuService(authProvider: authProvider);
    _isLoading = true;
    notifyListeners();
    try {
      final response = await restaurantService.getMenuById(id);
      _menuItem = MenuItem.fromJson(response['menu']);
      developer.log(jsonEncode(_menuItem?.toJson() ?? {}),
          name: 'getMenuById');
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
