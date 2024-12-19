import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/UserModel.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/AuthService.dart';
import 'package:foodly_ui/A-services/MenuService.dart';
import 'package:foodly_ui/A-services/RestaurantService.dart';
import 'dart:developer' as developer;

import 'package:foodly_ui/A-services/UserService.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLikked = false;
  bool _isLikkedM = false;
  User? _user;
  User? get user => _user;

  String _message = '';
  String _error = '';
  String _rating = '';
  String _mesagerating = '';

  bool get likked => _isLikked;
  bool get likkedM => _isLikkedM;

  bool get isLoading => _isLoading;
  String get message => _message;
  String get mesagerating => _mesagerating;

  String get error => _error;

  bool _isLikkedRestaurant = false;
  bool _isLikkedMrenu = false;

  String? _errorLiked;

  String? get errorLiked => _errorLiked;
  bool get restaurantLiked => _isLikkedRestaurant;
  bool get menuLiked => _isLikkedMrenu;

  String? get rating => _rating;
  Future<void> loadUser(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final _userService = UserService(authProvider: authProvider);
      final userData = await _userService.getUser();
      _user = User.fromJson(userData);
      developer.log('Total: $_user', name: '_user');

      notifyListeners();
    } catch (error) {
      notifyListeners();
    }
  }

  Future<void> likeMenu(BuildContext context, String menuId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _userService = UserService(authProvider: authProvider);
    _isLoading = true;
    notifyListeners();

    final response = await _userService.likeMenu(menuId);
    _isLoading = false;

    if (response['status']) {
      _message = response['message'];
      _rating = response['rating'];
      _isLikkedM = true;
      _error = '';
    } else {
      _error = response['error'];
      _isLikked = false;
    }

    notifyListeners();
  }

  Future<void> likerestaurant(BuildContext context, String restaurantId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _userService = UserService(authProvider: authProvider);
    _isLoading = true;
    notifyListeners();

    final response = await _userService.likerestaurant(restaurantId);
    _isLoading = false;

    if (response['status']) {
      _message = response['message'];
      _isLikked = true;

      _error = '';
    } else {
      _error = response['error'];
      _isLikked = false;
    }

    notifyListeners();
  }

  Future<void> dislikerestaurant(BuildContext context, restaurantId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _userService = UserService(authProvider: authProvider);
    _isLoading = true;
    notifyListeners();

    final response = await _userService.dislikerestaurant(restaurantId);
    _isLoading = false;

    if (response['status']) {
      _message = response['message'];
      _isLikked = false;
      print('Valeur de la variable: $_isLikked');

      _error = '';
    } else {
      _error = response['error'];
      _isLikked = false;
    }

    notifyListeners();
  }

  Future<void> dislikemenu(BuildContext context, menuId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _userService = UserService(authProvider: authProvider);
    _isLoading = true;
    notifyListeners();

    final response = await _userService.dislikemenu(menuId);
    _isLoading = false;

    if (response['status']) {
      _message = response['message'];
      _rating = response['rating'];

      _isLikkedM = false;
      print('Valeur de la variable: $_isLikkedM');

      _error = '';
    } else {
      _error = response['error'];
      _isLikked = false;
    }

    notifyListeners();
  }

  Future<void> checkUserlike(BuildContext context, restaurantId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final restaurantService = RestaurantService(authProvider: authProvider);

    _isLoading = true;
    notifyListeners();

    final response = await restaurantService.checkUserLike(restaurantId);

    developer.log("Response: ${jsonEncode(response)}", name: 'checkUserlike');

    _isLoading = false;

    _message = response['message'];
    _isLikkedRestaurant = response['liked'];
    developer.log("User like status: ${jsonEncode(_isLikked)}",
        name: 'checkUserlike');

    // _isLikked = false;
    // developer.log("User like status: false", name: 'checkUserlike');

    notifyListeners();
  }

  Future<void> checkUserlikeMenu(BuildContext context, menuId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final menuService = MenuService(authProvider: authProvider);

    _isLoading = true;
    notifyListeners();

    final response = await menuService.checkUserLike(menuId);

    // developer.log("Response: ${jsonEncode(response)}", name: 'checkmenulikes');

    _isLoading = false;

    _message = response['message'];
    _isLikkedMrenu = response['liked'];
    developer.log("User like status: ${jsonEncode(_isLikkedMrenu)}",
        name: 'checkUserlMenuike');

    notifyListeners();
  }
}
