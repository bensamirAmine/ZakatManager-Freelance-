import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/MenuItem.dart';
import 'package:foodly_ui/A-providers/MenuProvider.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart';
import 'package:foodly_ui/A-providers/SupplementProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:foodly_ui/constants.dart';
import 'package:provider/provider.dart';

class RestaurantMenuPage extends StatefulWidget {
  final String? menuId;

  const RestaurantMenuPage({
    super.key,
    required this.menuId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  int _quantity = 1; // Variable d'état pour gérer la quantité
  List<String> selectedSupplements = []; // Stocker les suppléments sélectionnés

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuProvider>(context, listen: false)
          .getMenuById(context, widget.menuId!);
      Provider.of<SupplementProvider>(context, listen: false)
          .getAllSuplements(context); // Charger les suppléments
    });
  }

  void _showFlashMessage(BuildContext context, String message) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 3),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          child: FlashBar(
            forwardAnimationCurve: Curves.fastOutSlowIn,
            reverseAnimationCurve: Curves.bounceIn,
            position: FlashPosition.top,
            backgroundColor: Colors.green[400],
            useSafeArea: true,
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.black, // Message text color
                fontSize: 16, // Font size of the message
              ),
            ),
            icon: const Icon(
              Icons.info_outline, // Optional icon
              color: Colors.black, // Icon color
            ),
            controller: controller,
            showProgressIndicator: true, // Show progress indicator
            padding: const EdgeInsets.all(16), // Padding inside the FlashBar
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final restaurantProvider =
    //     Provider.of<RestaurantProvider>(context, listen: false);
    // final restaurant = restaurantProvider.restaurant!;

    return Scaffold(
      body: SafeArea(
        child: Consumer<MenuProvider>(
          builder: (context, menuProvider, child) {
            if (menuProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (menuProvider.errorMessage != null) {
              return Center(child: Text(menuProvider.errorMessage!));
            } else if (menuProvider.menu == null) {
              return const Center(child: Text('No menu details available'));
            }

            final MenuItem? menuItem = menuProvider.menu;
            const String baseUrl = ApiEndpoints.ImageMenuURL;
            final String imageUrl = "$baseUrl${menuItem?.image}";

            return Stack(
              children: [
                // Afficher l'image du menu
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const AssetImage('assets/images/default_image.png')
                              as ImageProvider,
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
                        padding: const EdgeInsets.all(16.0),
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
                            // Détails du menu
                            Text(
                              menuItem?.name ?? 'No Name',
                              style: const TextStyle(
                                color: titleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "\$${menuItem?.price.toStringAsFixed(2) ?? '0.00'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              menuItem?.description ??
                                  'No description available',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Quantity:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (_quantity > 1) {
                                          setState(() {
                                            _quantity--;
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text(
                                      '$_quantity',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Sélection des suppléments
                            Consumer<SupplementProvider>(
                              builder: (context, supplementProvider, _) {
                                if (supplementProvider.isLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (supplementProvider.message != null) {
                                  return Center(
                                      child: Text(supplementProvider.message!));
                                } else if (supplementProvider
                                    .supplements.isEmpty) {
                                  return const Text('No supplements available');
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Choose your supplements:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          supplementProvider.supplements.length,
                                      itemBuilder: (context, index) {
                                        final supplement = supplementProvider
                                            .supplements[index];
                                        const String baseUrl =
                                            ApiEndpoints.ImagesupplementURL;
                                        final String imageUrl =
                                            "$baseUrl${supplement['image']}";

                                        final isSelected = selectedSupplements
                                            .contains(supplement['_id']);

                                        return ListTile(
                                          leading: Image.network(
                                            imageUrl,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(supplement['name']),
                                          subtitle: Text(
                                              'Prix: ${supplement['price'].toString()} €'),
                                          trailing: Checkbox(
                                            value: isSelected,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                if (value == true) {
                                                  selectedSupplements
                                                      .add(supplement['_id']);
                                                } else {
                                                  selectedSupplements.remove(
                                                      supplement['_id']);
                                                }
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Bouton Ajouter au panier
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final panierProvider =
                                      Provider.of<PanierProvider>(context,
                                          listen: false);
                                  panierProvider.addItemToPanier(
                                    context,
                                    menuItem!.id,
                                    menuItem.restaurant,
                                    _quantity.toString(),
                                    selectedSupplements,
                                  );
                                  _showFlashMessage(
                                      context, panierProvider.message!);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text("Add to Cart"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
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
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
