
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/Restaurant.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/screens/details/components/RestaurantMenuPage.dart';

import '../../../constants.dart';
import 'featured_item_card.dart';

class FeaturedItems extends StatelessWidget {
  final Restaurant restaurant;

  const FeaturedItems({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = restaurant.menu ?? [];

    const String baseUrl = ApiEndpoints.ImageMenuURL;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Top des ventes",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding / 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Use the null-aware operator to handle the case where menuItems is empty
              ...menuItems.map(
                (menuItem) {
                  final imageUrl = menuItem.image != null
                      ? "$baseUrl${menuItem.image}"
                      : "$baseUrl/default_image.png"; // Fallback image if necessary
                   return Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: FeaturedItemCard(
                      title: menuItem.name ??
                          'No Name', // Provide default values if necessary
                      image: imageUrl, // Concatenate base URL with image path
                      foodType: menuItem.specialty ??
                          'Unknown', // Provide default values if necessary
                      priceRange:
                          "\$${menuItem.price?.toStringAsFixed(2) ?? '0.00'}",
                      press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantMenuPage(
                            menuId: menuItem.id, // Pass menuId to the next page
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
              const SizedBox(width: defaultPadding),
            ],
          ),
        ),
      ],
    );
  }
}
