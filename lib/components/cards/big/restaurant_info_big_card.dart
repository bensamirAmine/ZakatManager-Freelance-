import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';

import '../../../constants.dart';

class RestaurantInfoBigCard extends StatelessWidget {
  final String image,
      name,
      street,
      city,
      country,
      phoneNumber,
      deliveryTime,
      openingHours;
  final double rating;
  final bool isFreeDelivery;
  final VoidCallback press;

  const RestaurantInfoBigCard({
    super.key,
    required this.name,
    required this.street,
    required this.city,
    required this.country,
    required this.rating,
    required this.deliveryTime,
    this.isFreeDelivery = true,
    required this.press,
    required this.image,
    required this.phoneNumber,
    required this.openingHours,
  });

  get numOfRating => 1;

  @override
  Widget build(BuildContext context) {
    const String baseUrl = ApiEndpoints.ImageRestaurantURL;
    final String imageUrl = "$baseUrl$image";
    return InkWell(
      onTap: press,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for images
            SizedBox(
              height: 239,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 4),

                  // Restaurant Address
                  Text(
                    '$street, $city, $country',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: defaultPadding / 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.thumb_up_alt_outlined,
                            color: primaryColor,
                            size: 15,
                          ),
                          const SizedBox(width: defaultPadding / 2),
                          Text(
                            "$rating%",
                            // Convert rating to string
                            style: const TextStyle(
                              fontSize: 15,
                              color: bodyTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      const Icon(
                        Icons.motorcycle_rounded,
                        color: primaryColor,
                      ),
                      Text(
                        deliveryTime,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      SvgPicture.asset(
                        "assets/icons/delivery.svg",
                        height: 20,
                        width: 20,
                        colorFilter: const ColorFilter.mode(
                          Colors.green,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        isFreeDelivery ? "Free" : "Paid",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
