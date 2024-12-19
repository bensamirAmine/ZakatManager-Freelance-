import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart';
import 'package:foodly_ui/A-providers/RestaurantProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/screens/details/components/featured_items.dart';
import 'package:foodly_ui/screens/details/components/iteams.dart';
import 'package:foodly_ui/screens/details/components/restaurrant_info.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_by_restaurant_screen.dart';

import 'package:provider/provider.dart';
import 'package:foodly_ui/constants.dart';

class DetailsScreen extends StatelessWidget {
  final String restaurantId;

  const DetailsScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    final panierProvider = Provider.of<PanierProvider>(context, listen: false);

    // Appeler la méthode pour récupérer le nombre total d'articles au chargement de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      panierProvider.totalUserOrdersByRestaurant(context, restaurantId);
    });

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: restaurantProvider.getRestaurantById(context, restaurantId),
          builder: (context, snapshot) {
            if (restaurantProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (restaurantProvider.errorMessage != null) {
              return Center(
                  child: Text('Erreur: ${restaurantProvider.errorMessage}'));
            } else if (restaurantProvider.restaurant == null) {
              return const Center(child: Text('Restaurant Not Found'));
            } else {
              final restaurant = restaurantProvider.restaurant!;
              const String baseUrl = ApiEndpoints.ImageRestaurantURL;
              final String image = restaurant.image ?? '';
              final String imageUrl = "$baseUrl$image";

              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RestaurantInfo(restaurant: restaurant),
                              const SizedBox(height: defaultPadding),
                              FeaturedItems(restaurant: restaurant),
                              Items(restaurant: restaurant),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: [
                        Consumer<PanierProvider>(
                          builder: (context, panierProvider, child) {
                            return Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 700,
                                          color: Colors.white,
                                          child: Center(
                                            child:
                                                OrderDetailsByRestaurantScreen(
                                                    restaurantId: restaurantId),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                // Si le nombre d'articles est supérieur à 0, afficher le badge
                                if (panierProvider.paniernbr != null &&
                                    panierProvider.paniernbr! >= 0)
                                  Positioned(
                                    right: 6,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        panierProvider.paniernbr!.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
