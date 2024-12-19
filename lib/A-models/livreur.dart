class Livreur {
  final String id; // Corresponds to MongoDB's ObjectId
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String status;
  final bool banned;
  final bool etatDelete;
  final bool verified;
  DeliveryLocation deliveryLocation;

  final DateTime createdAt;
  final DateTime updatedAt;

  Livreur(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.email,
      required this.phoneNumber,
      required this.deliveryLocation,
      required this.password,
      this.banned = false,
      this.etatDelete = false,
      this.verified = false,
      required this.createdAt,
      required this.updatedAt,
      required this.status});

  // Factory constructor to parse JSON data (from MongoDB)
  factory Livreur.fromJson(Map<String, dynamic> json) {
    return Livreur(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      deliveryLocation: DeliveryLocation.fromJson(json['deliveryLocation']),
      password: json['password'] as String,
      status: json['status'] as String,
      banned: json['banned'] as bool? ?? false,
      etatDelete: json['etatDelete'] as bool? ?? false,
      verified: json['verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert the Dart object back to JSON (e.g., to send to server)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'deliveryLocation': deliveryLocation.toJson(),
      'password': password,
      'banned': banned,
      'etatDelete': etatDelete,
      'status': status,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class DeliveryLocation {
  double latitude;
  double longitude;

  DeliveryLocation({required this.latitude, required this.longitude});

  // Méthode pour convertir un document JSON en instance de DeliveryLocation
  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
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
