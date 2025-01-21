
import 'package:foodly_ui/A-models/MenuItem.dart';
import 'package:foodly_ui/A-models/supplement.dart';

class PanierItem {
  final String id;
  final String restaurantId;

  final String user;
  List<dynamic>? menuItem;
  final int quantity;
  List<dynamic>? supplement;

  final String subtotal;

  PanierItem({
    required this.id,
    required this.user,
    required this.restaurantId,
    required this.menuItem,
    required this.subtotal,
    required this.quantity,
    required this.supplement,
  });

  factory PanierItem.fromJson(Map<String, dynamic> json) {
    return PanierItem(
      id: json['_id'] as String,
      user: json['user'] as String,
      restaurantId: json['restaurant'] as String,
      quantity: json['quantity'] as int,
      subtotal: json['subtotal'] as String,
      menuItem: (json['menuItem'] as List<dynamic>?)?.map((item) {
        if (item is Map<String, dynamic>) {
          return MenuItem.fromJson(item);
        }
        return item as String;
      }).toList(),
      supplement: (json['supplement'] as List<dynamic>?)?.map((item) {
        if (item is Map<String, dynamic>) {
          return Supplement.fromJson(item);
        }
        return item as String;
      }).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'restaurant': restaurantId,
      'quantity': quantity,
      'subtotal': subtotal,
      'menuItem': menuItem?.map((item) {
        if (item is MenuItem) {
          return item.toJson();
        }
        return item;
      }).toList(),
      'supplement': supplement?.map((item) {
        if (item is MenuItem) {
          return item.toJson();
        }
        return item;
      }).toList(),
    };
  }
}
