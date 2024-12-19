import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/livreur.dart';
import 'package:foodly_ui/A-services/AuthService.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/entry_point.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final AuthService _loginService = AuthService();
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _token = '';
  String _message = '';
  String _error = '';
  Livreur? _livreur;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get token => _token;
  String get message => _message;
  String get error => _error;
  Livreur? get livreur => _livreur;
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      User? user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          print("Verification email sent to ${user.email}");
        }

        // Envoi du idToken au backend
        final result = await sendIdTokenToBackend(gAuth.idToken!);

        if (result['status']) {
          _token = result['token'];
          _message = result['message']; // Stockage du message
          _loginService.saveToken(_token); // Sauvegarde du token
        } else {
          // Gestion des erreurs
          _error = result['error'];
          print("Erreur lors de l'envoi du idToken: ${_error}");
          return;
        }

        // Navigation vers EntryPoint
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EntryPoint()),
        );
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  Future<Map<String, dynamic>> sendIdTokenToBackend(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.verif_google_login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Retourner un format similaire à login
        return {
          'status': responseBody[
              'status'], // Assurer que le champ 'status' existe dans la réponse
          'token': responseBody[
              'token'], // Assurer que le champ 'token' existe dans la réponse
          'message': responseBody[
              'message'], // Assurer que le champ 'message' existe dans la réponse
        };
      } else if (response.statusCode == 404) {
        return {
          'status': false,
          'error': 'User not found',
        };
      } else {
        return {
          'status': false,
          'error': 'Unknown error occurred',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'error': 'Failed to send idToken: $e',
      };
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _loginService.login(email, password);
    _isLoading = false;

    if (response['status']) {
      _token = response['token'];
      _message = response['message'];
      _isLoggedIn = true;
      _loginService.saveToken(_token);

      developer.log(jsonEncode(_token), name: 'AuthToken');
      _error = '';
    } else {
      _error = response['error'];
      _isLoggedIn = false;
    }

    notifyListeners();
  }

  Future<void> livreurlogin(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _loginService.livreurLogin(email, password);
    _isLoading = false;

    if (response['status']) {
      _token = response['token'];
      _message = response['message'];
      _livreur = Livreur.fromJson(response['user']);
      _isLoggedIn = true;
      _loginService.saveToken(_token);

      developer.log(jsonEncode(_token), name: 'AuthToken');
      _error = '';
    } else {
      _error = response['error'];
      _isLoggedIn = false;
    }

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _loginService.removeToken();
    notifyListeners();
  }
}
