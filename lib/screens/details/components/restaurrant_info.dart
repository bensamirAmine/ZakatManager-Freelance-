import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/Restaurant.dart';
import 'package:foodly_ui/A-providers/UserProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/constants.dart';
import 'package:provider/provider.dart';

class RestaurantInfo extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantInfo({
    super.key,
    required this.restaurant,
  });

  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  @override
  void initState() {
    super.initState();
    _checkUserLike();
  }

  Future<void> _checkUserLike() async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    await userprovider.checkUserlike(context, widget.restaurant.id);
  }

  @override
  Widget build(BuildContext context) {
    const String baseUrl = ApiEndpoints.ImageRestaurantURL;
    final String image = widget.restaurant.image ?? '';
    final String street = widget.restaurant.street;
    final String city = widget.restaurant.city;
    final String codePostal = widget.restaurant.postalCode;
    final String country = widget.restaurant.country;
    final String phoneNumber = widget.restaurant.phoneNumber;

    final String location = "$street, $city, $country";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.restaurant.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "CP:$codePostal",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DeliveryInfo(
                    iconSrc: Icons.timer_rounded,
                    text: "Temps de livraison",
                    subText: widget.restaurant.deliveryTime,
                  ),
                  DeliveryInfo(
                    iconSrc: Icons.phone,
                    text: "Appeler",
                    subText: phoneNumber,
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return GestureDetector(
                        onTap: () async {
                          if (userProvider.restaurantLiked) {
                            await userProvider.dislikerestaurant(
                                context, widget.restaurant.id);
                          } else {
                            await userProvider.likerestaurant(
                                context, widget.restaurant.id);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                userProvider.restaurantLiked
                                    ? userProvider.message
                                    : userProvider.error,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Icon(
                              userProvider.restaurantLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_alt_outlined,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Évaluation",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Colors.grey[600], fontSize: 12),
                            ),
                            Text(
                              "${widget.restaurant.rating!}%",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Horaires d'ouverture",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                widget.restaurant.openingHours,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({
    super.key,
    required this.iconSrc,
    required this.text,
    required this.subText,
    this.onTap,
  });

  final String text;
  final String subText;
  final IconData iconSrc;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          iconSrc,
          color: primaryColor,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.grey[600], fontSize: 12),
        ),
        Text(
          subText,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
