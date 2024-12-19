import 'dart:developer' as developer;

class MenuItem {
  final String id;
  final String restaurant;
  final String name;
  final String typeMenu;
  final String specialty;
  final double price;
  final String description;
  // final bool available;
  final String image;
  final String rating;
  final List<dynamic> likes;

  MenuItem({
    required this.id,
    required this.restaurant,
    required this.name,
    required this.typeMenu,
    required this.specialty,
    required this.price,
    required this.description,
    // required this.available,
    required this.image,
    required this.rating,
    required this.likes,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'] as String,
      restaurant: json['restaurant'] as String,
      name: json['name'] as String,
      typeMenu: json['typeMenu'] as String,
      specialty: json['specialty'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      // available: json['available'] is bool
      //     ? json['available'] as bool
      //     : json['available'] ==
      //         'true', // Si c'est une chaîne, convertir en booléen
      image: json['image'] as String,
      rating: json['rating'] as String,
      likes: List<dynamic>.from(json['likes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurant': restaurant,
      'name': name,
      'typeMenu': typeMenu,
      'specialty': specialty,
      'price': price,
      'description': description,
      // 'available': available,
      'image': image,
      'rating': rating,
      'likes': likes,
    };
  }
}
