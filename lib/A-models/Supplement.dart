import 'dart:developer' as developer;

import 'package:foodly_ui/A-models/MenuItem.dart';

class Supplement {
  final String id;

  final String name;
  final String type;

  final String price;
  final int image;

  Supplement({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.image,
  });

  factory Supplement.fromJson(Map<String, dynamic> json) {
    return Supplement(
      id: json['_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      image: json['image'] as int,
      price: json['price'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'price': price,
      'image': image,
    };
  }
}
