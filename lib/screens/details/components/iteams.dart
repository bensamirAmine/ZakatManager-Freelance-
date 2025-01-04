import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/Restaurant.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/screens/details/components/RestaurantMenuPage.dart';
import 'package:foodly_ui/screens/details/details_screen.dart';
import '../../../components/cards/iteam_card.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';

class Items extends StatefulWidget {
  final Restaurant restaurant;
  const Items({super.key, required this.restaurant});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    final menuItems = widget.restaurant.menu ?? [];
    const String baseUrl = ApiEndpoints.ImageMenuURL;

    final List<dynamic> menuTypes = menuItems
        .map((menuItem) => menuItem.typeMenu ?? 'Unknown')
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTabController(
          length: menuTypes.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                unselectedLabelColor: titleColor,
                labelStyle: Theme.of(context).textTheme.titleLarge,
                onTap: (value) {
                  // Handle tab selection if necessary
                },
                tabs: menuTypes.map((menuType) {
                  return Tab(child: Text(menuType));
                }).toList(),
              ),
              const SizedBox(height: defaultPadding),
              // Use a TabBarView to show the menu items for each type
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  children: menuTypes.map((menuType) {
                    // Filter menu items by the selected menuType
                    final filteredItems = menuItems
                        .where((menuItem) => menuItem.typeMenu == menuType)
                        .toList();

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final menuItem = filteredItems[index];
                        final imageUrl = menuItem.image != null
                            ? "$baseUrl${menuItem.image}"
                            : "$baseUrl/default_image.png";

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding / 2),
                          child: ItemCard(
                            title: menuItem.name ?? 'No Name',
                            description:
                                menuItem.description ?? 'No Description',
                            image: imageUrl,
                            foodType: menuItem.typeMenu ?? 'No Type',
                            price: menuItem.price ?? 0.0,
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RestaurantMenuPage(menuId: menuItem.id),

                                // builder: (context) => const AddToOrderScrreen(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
