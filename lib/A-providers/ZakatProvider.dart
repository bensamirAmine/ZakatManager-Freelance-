import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/MenuItem.dart';
import 'package:foodly_ui/A-models/Transaction.dart';

import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-providers/UserProvider.dart';
import 'package:foodly_ui/A-services/ZakatService.dart';
import 'dart:developer' as developer;

import 'package:provider/provider.dart';

class ZakatProvider with ChangeNotifier {
  String? _errorMessage;
  List<Transaction> _history = [];
  bool _isLoading = false;
  MenuItem? _menuItem;
  String? _message;
  String? _message3;
  String? _messageD;
  double? _zakatAmount;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String? get message => _message;

  String? get messageD => _messageD;

  double? get zakatAmount => _zakatAmount;

  String? get messageU => _message3;

  List<Transaction> get history => _history;

  MenuItem? get menu => _menuItem;

  Future<void> recalculateTotals(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final zakatService = ZakatService(authProvider: authProvider);

    _setLoadingState(true);

    try {
      final UserTotals userTotals = await zakatService.recalculateTotals();

      _zakatAmount = userTotals.total;
      _history = userTotals.history;

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> deleteTransaction(
      BuildContext context, String transactionId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final zakatService = ZakatService(authProvider: authProvider);

    _setLoadingState(true);

    try {
      _messageD = await zakatService.deleteTransaction(transactionId);
      // await recalculateTotals(context);
      _history = _history.where((tx) => tx.id != transactionId).toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> AddTransaction(BuildContext context, String type,
      String category, double amount, String acquisitionDate) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final zakatService = ZakatService(authProvider: authProvider);
    _setLoadingState(true);

    try {
      final response = await zakatService.AddTransaction(
          type, category, amount, acquisitionDate);
      _message = response['message'];

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUser(context);
      recalculateTotals(context);
      notifyListeners();

      developer.log(_message!, name: '_message');
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
