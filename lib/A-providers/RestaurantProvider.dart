import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/MenuItem.dart';
import 'package:foodly_ui/A-models/Restaurant.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-services/AuthService.dart';
import 'package:foodly_ui/A-services/RestaurantService.dart';
import 'dart:developer' as developer;

import 'package:provider/provider.dart';

class RestaurantProvider with ChangeNotifier {
  List<dynamic> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage;
  Restaurant? _restaurant;
  final bool _isLikked = false;
  String? _message;
  String? _errorLiked;
  List<dynamic> _filteredRestaurants = [];
  List<dynamic> _filteredMenus = [];

  List<dynamic> get filteredRestaurants => _filteredRestaurants;
  List<dynamic> get filteredMenus => _filteredMenus;

  List<dynamic> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  // ignore: non_constant_identifier_names
  String? get Message => _message;
  String? get errorLiked => _errorLiked;
  bool get likked => _isLikked;

  Restaurant? get restaurant => _restaurant;
  Future<void> getRestaurantById(BuildContext context, String id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final restaurantService = RestaurantService(authProvider: authProvider);

    _isLoading = true;
    notifyListeners();
    try {
      final response = await restaurantService.getRestaurantById(id);
      _restaurant = Restaurant.fromJson(response['restaurant']);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurants(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final restaurantService = RestaurantService(authProvider: authProvider);

    _isLoading = true;
    notifyListeners();
    try {
      _restaurants = await restaurantService.fetchRestaurants();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterRestaurants(String query) {
    if (query.isEmpty) {
      _filteredRestaurants = [];
      _filteredMenus = [];
    } else {
      _filteredRestaurants = _restaurants.where((restaurant) {
        if (restaurant is Map<String, dynamic>) {
          final name = restaurant['name'];

          return name != null &&
              name.toString().toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();

      _filteredMenus = [];

      for (var restaurant in _filteredRestaurants) {
        if (restaurant is Map<String, dynamic>) {
          final restaurantName = restaurant['name'];
          // print("reestauarnt" + restaurantName);
          if (restaurantName != null &&
              restaurantName
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
            final menuList = restaurant['menu'] ?? [];

            for (var menuItem in menuList) {
              if (menuItem is MenuItem) {
                _filteredMenus.add(menuItem);
              } else if (menuItem is Map<String, dynamic>) {
                _filteredMenus.add(MenuItem.fromJson(menuItem));
              }
            }
          }
        }

        // developer.log(
        //     '_____________Filtered restaurants: ${jsonEncode(_filteredRestaurants)}',
        //     name: 'filteredRestaurants');
        // developer.log(
        //     '****************Filtered menus: ${jsonEncode(_filteredMenus)}',
        //     name: 'filteredMenus');
      }
      notifyListeners();
    }

    void filterMenusByRestaurantName(String query) {
      developer.log('Filtering menus for restaurant with query: $query',
          name: 'filterQuery');

      if (query.isEmpty) {
        _filteredMenus = [];
      } else {
        _filteredMenus = [];

        for (var restaurant in _restaurants) {
          if (restaurant is Map<String, dynamic>) {
            final restaurantName =
                restaurant['name']; // Récupérer le nom du restaurant

            if (restaurantName != null &&
                restaurantName
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
              final menuList = restaurant['menu'] ??
                  []; // Récupérer les menus de ce restaurant

              // Log pour vérifier les menus du restaurant trouvé
              developer.log(
                  'Menus for restaurant "$restaurantName": ${jsonEncode(menuList)}',
                  name: 'menuList');

              // Ajouter les menus de ce restaurant à la liste filtrée
              for (var menuItem in menuList) {
                if (menuItem is MenuItem) {
                  _filteredMenus.add(menuItem);
                }
              }

              // Une fois le restaurant trouvé, on sort de la boucle
              break;
            }
          }
        }

        // Log de la liste des menus filtrés
        developer.log('Filtered menus: ${jsonEncode(_filteredMenus)}',
            name: 'filteredMenus');
      }

      // Notifier les auditeurs après la mise à jour
      notifyListeners();
    }

    void filterMenus(String query) {
      developer.log('Filtering restaurants with query: $query',
          name: 'filterQuery');

      if (query.isEmpty) {
        // Si la requête est vide, réinitialiser la liste filtrée
        _filteredMenus = [];
      } else {
        // Initialiser une nouvelle liste pour stocker les menus filtrés
        _filteredMenus = [];

        // Parcourir chaque restaurant
        for (var restaurant in _restaurants) {
          if (restaurant is Map<String, dynamic>) {
            final menuList = restaurant['menu'] ?? [];

            // Log pour vérifier le contenu de chaque menu
            developer.log(
                'Restaurant menus: ${jsonEncode(menuList.toString())}',
                name: 'menuList');

            // Filtrer les éléments du menu en fonction de la requête
            final filteredMenu = menuList.where((menuItem) {
              if (menuItem is MenuItem) {
                final itemName = menuItem.name;
                print("hello");
                // Log pour vérifier chaque nom d'item
                developer.log('Menu item name: $itemName',
                    name: 'menuItemName');

                // Vérifier la correspondance avec la requête
                return itemName.toLowerCase().contains(query.toLowerCase());
              }
              return false;
            }).toList();

            // Ajouter uniquement les éléments filtrés à la liste _filteredMenus
            if (filteredMenu.isNotEmpty) {
              _filteredMenus.addAll(filteredMenu);
            }
          }
        }

        // Log pour afficher les menus filtrés
        developer.log('Filtered menus: ${jsonEncode(_filteredMenus)}',
            name: 'filteredMenus');
      }

      // Notifier les auditeurs que la liste a été mise à jour
      notifyListeners();
    }
  }
}
