import 'package:foodly_ui/A-models/PanierItem.dart';

class Commande {
  String? id;
  String userId;
  String restaurantId;
  List<dynamic> panierItems;
  DeliveryLocation deliveryLocation;
  String deliveryAddress;
  String paymentMethod;
  double? totalProductAmount;
  double totalAmount;
  String status;
  DateTime? orderDate;

  // Constructeur
  Commande({
    this.id,
    required this.userId,
    required this.restaurantId,
    required this.panierItems,
    required this.deliveryLocation,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.totalProductAmount,
    required this.totalAmount,
    this.status = 'En attente',
    DateTime? orderDate,
  }) : orderDate = orderDate ?? DateTime.now();

  // Méthode pour convertir un document JSON en instance de Commande
  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      id: json['_id'] as String?,
      userId: json['user'] as String,
      restaurantId: json['restaurant'] as String,
      panierItems: List<PanierItem>.from(json['panierItems']),
      deliveryLocation: DeliveryLocation.fromJson(json['deliveryLocation']),
      deliveryAddress: json['deliveryAddress'] as String,
      paymentMethod: json['paymentMethod'] as String,
      totalProductAmount: json['totalProductAmount'] as double?,
      totalAmount: json['totalAmount'] as double,
      status: json['status'] as String,
      orderDate: DateTime.parse(json['orderDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'restaurant': restaurantId,
      'panierItems': panierItems,
      'deliveryLocation': deliveryLocation.toJson(),
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'totalProductAmount': totalProductAmount,
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate!.toIso8601String(),
    };
  }
}

// Classe pour la localisation de livraison (DeliveryLocation)
class DeliveryLocation {
  double latitude;
  double longitude;

  DeliveryLocation({required this.latitude, required this.longitude});

  // Méthode pour convertir un document JSON en instance de DeliveryLocation
  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  // Méthode pour convertir une instance de DeliveryLocation en JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
