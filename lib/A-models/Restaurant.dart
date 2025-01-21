import 'package:foodly_ui/A-models/MenuItem.dart';

class Restaurant {
  final String id;
  final String name;
  final String password;
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final String phoneNumber;
  final String openingHours;
  final String? description;
  final String? image;
  final String? rating;
  final String deliveryTime;
  List<dynamic>? menu;
  final CurrentLocation currentLocation;
  final List<String>? likes;

  Restaurant({
    required this.id,
    required this.name,
    required this.password,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phoneNumber,
    required this.openingHours,
    this.description,
    this.image,
    this.rating,
    required this.deliveryTime,
    this.menu,
    required this.currentLocation,
    this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'password': password,
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'phoneNumber': phoneNumber,
      'openingHours': openingHours,
      'description': description,
      'image': image,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'menu': menu?.map((item) {
        if (item is MenuItem) {
          return item
              .toJson(); // Si c'est un objet MenuItem, le convertir en JSON
        }
        return item; // Si c'est un ID (String), le laisser tel quel
      }).toList(),
      'currentLocation': currentLocation.toJson(),
      'likes': likes,
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'],
      name: json['name'],
      password: json['password'],
      street: json['street'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
      phoneNumber: json['phoneNumber'],
      openingHours: json['openingHours'],
      description: json['description'],
      image: json['image'],
      rating: json['rating'],
      deliveryTime: json['deliveryTime'] as String,
      menu: (json['menu'] as List<dynamic>?)?.map((item) {
        if (item is Map<String, dynamic>) {
          return MenuItem.fromJson(item);
        }
        return item as String;
      }).toList(),
      currentLocation: CurrentLocation.fromJson(json['currentLocation']),
      likes: List<String>.from(json['likes'] ?? []),
    );
  }
}

class CurrentLocation {
  final String latitude;
  final String longitude;

  CurrentLocation({
    required this.latitude,
    required this.longitude,
  });

  // Convertir un objet CurrentLocation en Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Convertir un Map (JSON) en objet CurrentLocation
  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }
}
