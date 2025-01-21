
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/SupplementService.dart';

import 'package:provider/provider.dart';

class SupplementProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _message;

  bool get isLoading => _isLoading;
  String? get message => _message;

  List<dynamic> _supplements = [];
  List<dynamic> get supplements => _supplements;

  Future<void> getAllSuplements(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final supplementService = SupplementService(authProvider: authProvider);
    _isLoading = true;
    notifyListeners();
    try {
      _supplements = await supplementService.getALlSupplements();
      // developer.log("Response: ${jsonEncode(_supplements)}",
      //     name: '_supplements ');()
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Supplement')),
      // );
      notifyListeners();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
