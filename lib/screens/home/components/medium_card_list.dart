import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-providers/RestaurantProvider.dart';
import 'package:provider/provider.dart';
import '../../../components/cards/medium/restaurant_info_medium_card.dart';
import '../../../components/scalton/medium_card_scalton.dart';
import '../../../constants.dart';
import '../../details/details_screen.dart';
import 'dart:developer' as developer;

class MediumCardList extends StatefulWidget {
  const MediumCardList({super.key});

  @override
  State<MediumCardList> createState() => _MediumCardListState();
}

class _MediumCardListState extends State<MediumCardList> {
  @override
  void initState() {
    super.initState();

    // Fetch the restaurants after the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(context, listen: false)
          .fetchRestaurants(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);
    final isLoading = provider.isLoading;
    final restaurants = provider.restaurants;

    // Imprime les données récupérées

    return SizedBox(
      height: 254, // Fix the height to avoid overflow
      child: isLoading
          ? buildFeaturedPartnersLoadingIndicator()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: (restaurants.length - 1) == index ? defaultPadding : 0,
                ),
                child: RestaurantInfoMediumCard(
                  image: restaurants[index]['image'] ?? '',
                  name: restaurants[index]['name'] ?? '',
                  phoneNumber: restaurants[index]['phoneNumber'] ?? '',
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        restaurantId: restaurants[index]
                            ['_id'], // Passer l'ID ici
                      ),
                    ),
                  ),
                  street: restaurants[index]['street'] ?? '',
                  city: restaurants[index]['city'] ?? '',
                  country: restaurants[index]['country'] ?? '',
                  deliveryTime: restaurants[index]['deliveryTime'] ?? '',
                  rating: double.tryParse(
                          restaurants[index]['rating']?.toString() ?? '') ??
                      0.0,
                ),
              ),
            ),
    );
  }

  SingleChildScrollView buildFeaturedPartnersLoadingIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(left: defaultPadding),
            child: MediumCardScalton(),
          ),
        ),
      ),
    );
  }
}
