import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/A-providers/RestaurantProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/components/cards/iteam_card.dart';
import 'package:foodly_ui/screens/details/components/RestaurantMenuPage.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSearchResult = false;

  @override
  void initState() {
    super.initState();
    // Load restaurants on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider =
          Provider.of<RestaurantProvider>(context, listen: false);
      searchProvider.fetchRestaurants(context);
    });
  }

  void showResult() {
    if (mounted) {
      setState(() {
        _showSearchResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final restaurants = restaurantProvider.filteredRestaurants;
    final menus = restaurantProvider.filteredMenus;

    final List<dynamic> menuTypes = menus
        .map((menuItem) => menuItem.typeMenu ?? 'Unknown')
        .toSet()
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Area
              const SizedBox(height: defaultPadding),
              Text('Search', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: defaultPadding),
              SearchForm(onSearch: (query) {
                restaurantProvider.filterRestaurants(query);
                showResult();

              }),
              
              const SizedBox(height: defaultPadding),

              // ),
              const SizedBox(height: defaultPadding),
              // Display restaurant info and menus like Instagram profile layout
              restaurantProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = restaurants[index];

                        String name =
                            restaurant['name'] ?? 'Unknown Restaurant';
                        String deliveryTime =
                            restaurant['deliveryTime'] ?? 'N/A';
                        String image = restaurant['image'] ??
                            'default_image_path.png'; // Default image path
                        String phoneNumber = restaurant['phoneNumber'] ?? 'N/A';
                        String rating = restaurant['rating'] ?? 0;
                        // String openingHours =
                        //     restaurant['openingHours'] ?? 'N/A';
                        const String baseUrl1 = ApiEndpoints.ImageRestaurantURL;
                        const String baseUrl2 = ApiEndpoints.ImageMenuURL;

                        final String imageUrl = "$baseUrl1$image";
                        // Instagram profile-style header for restaurant
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white12,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(imageUrl),
                                    ),
                                    const SizedBox(width: defaultPadding),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        
                                        Text(name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        const SizedBox(height: 8),
                                        Text('Delivery: $deliveryTime',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),

                                        Text('Phone: $phoneNumber',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                                
                                        // Text('Hours: $openingHours'),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: defaultPadding,
                                    ),
                                    Text(
                                      "%$rating",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Colors.grey[600],
                                              fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.thumb_up_off_alt,
                                      color: primaryColor,
                                      size: 15,
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultTabController(
                                    length: menuTypes.length,
                                    child: Column(
                                      children: [
                                        TabBar(
                                          indicatorColor: primaryColor,
                                          indicatorWeight: 5,
                                          isScrollable: true,
                                          unselectedLabelColor: bodyTextColor,
                                          labelStyle: const TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: smalltitle),
                                          onTap: (value) {},
                                          tabs: menuTypes.map((menuType) {
                                            return Tab(child: Text(menuType));
                                          }).toList(),
                                        ),
                                        const SizedBox(height: defaultPadding),
                                        // Use a TabBarView to show the menu items for each type
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          child: TabBarView(
                                            children: menuTypes.map((menuType) {
                                              // Filter menu items by the selected menuType
                                              final filteredItems = menus
                                                  .where((menuItem) =>
                                                      menuItem.typeMenu ==
                                                      menuType)
                                                  .toList();

                                              return ListView.builder(
                                                itemCount: filteredItems.length,
                                                itemBuilder: (context, index) {
                                                  final menuItem =
                                                      filteredItems[index];
                                                  final imageUrl = menuItem
                                                              .image !=
                                                          null
                                                      ? "$baseUrl2${menuItem.image}"
                                                      : "$baseUrl2/default_image.png";
                                                  final menuID = menuItem.id;
                                                  print(
                                                      'Navigating with menuID: $menuID');

                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                            defaultPadding,
                                                        vertical:
                                                            defaultPadding / 2),
                                                    child: ItemCard(
                                                      title: menuItem.name ??
                                                          'No Name',
                                                      description: menuItem
                                                              .description ??
                                                          'No Description',
                                                      image: imageUrl,
                                                      foodType: '',
                                                      price:
                                                          menuItem.price ?? 0.0,
                                                      press: () =>
                                                          Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              RestaurantMenuPage(
                                                                  menuId:
                                                                      menuItem
                                                                          .id),
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
                              )
                            ]
                            // Display restaurant's menus in grid view
                            // GridView.builder(
                            //   shrinkWrap: true,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   gridDelegate:
                            //       const SliverGridDelegateWithFixedCrossAxisCount(
                            //     crossAxisCount: 2,
                            //     childAspectRatio: 0.75, // Adjust as needed
                            //     crossAxisSpacing: 10,
                            //     mainAxisSpacing: 10,
                            //   ),
                            //   itemCount: menus.length,
                            //   itemBuilder: (context, index) {
                            //     var menu = menus[index];

                            //     String name = menu.name;
                            //     double price = menu.price != null
                            //         ? double.tryParse(menu.price.toString()) ??
                            //             0.0
                            //         : 0.0;
                            //     const String baseUrl =
                            //         ApiEndpoints.ImageMenuURL;

                            //     final image = menu.image != null
                            //         ? "$baseUrl${menu.image}"
                            //         : "$baseUrl/default_image.png"; // Fallback image

                            //     return MenuItemCard(
                            //       title: name,
                            //       price: price.toString(),
                            //       image: image,
                            //       onPress: () {
                            //         // Action when menu item is pressed
                            //       },
                            //     );
                            //   },
                            // ),

                            );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final VoidCallback onPress;

  const MenuItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(image, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  color: titleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 4),
            Text(
              'DT $price',
              // style: Theme.of(context).textTheme.bodySmall
              style: const TextStyle(
                  color: titleColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  final Function(String) onSearch;

  const SearchForm({super.key, required this.onSearch});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          if (value.isNotEmpty) {
            widget.onSearch(value);
          } else {
            widget.onSearch(value);
          }
        },
        validator: (value) =>
            value!.isEmpty ? "This field cannot be empty" : null,
        style: Theme.of(context).textTheme.labelLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search on Foodly",
          contentPadding: kTextFieldPadding,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                bodyTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
