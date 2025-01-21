import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-providers/LivreurProvider.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/Delivered/OrderDetailsPage.dart';
import 'package:foodly_ui/screens/Map/Carte.dart';
import 'package:foodly_ui/screens/auth/sign_in_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryOrdersPage extends StatefulWidget {
  const DeliveryOrdersPage({super.key});

  @override
  _DeliveryOrdersPageState createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {
  double latitude = 0;
  double longitude = 0;
  bool _useCurrentLocation = false;
  String _currentAddress = '';
  bool _isLocationLoading = false;
  bool _isAvaiblable = false;

  bool _locationFetched = false;
  double _sliderValue = 100; // Initial value for the slider
  final double min = 100 / 1000;
  final double max = 7000 / 1000;
  @override
  void initState() {
    super.initState();
    // Fetch nearby orders when the page loads
    final livreurProvider =
        Provider.of<LivreurProvider>(context, listen: false);
    // livreurProvider.fetchNearbyOrders(
    //     context, _sliderValue); // Call to fetch orders
  }

  void getLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      setState(() {
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address =
              "${place.street}, ${place.locality}, ${place.country}";
          _currentAddress = address;
          _locationFetched = true;
        }
      });

      final livreurProvider =
          Provider.of<LivreurProvider>(context, listen: false);
      await livreurProvider.updateItem(
          context, latitude, longitude, _sliderValue);
    } catch (e) {
      print('Erreur: $e');
    } finally {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final livreurProvider = Provider.of<LivreurProvider>(context);

    if (!authProvider.isLoggedIn) {
      return const Center(
        child: Text("Veuillez vous connecter pour voir vos informations."),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenue, ${authProvider.livreur!.lastName}',
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_useCurrentLocation &&
                  _locationFetched &&
                  _currentAddress.isNotEmpty)
                Card(
                  elevation: 10,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Adresse sélectionnée:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _currentAddress,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.connect_without_contact_sharp,
                    color: primaryColor),
                title: Text(
                  ' ${authProvider.livreur!.status}',
                  style: const TextStyle(color: titleColor),
                ),
                trailing: Switch(
                  inactiveTrackColor: Colors.grey,
                  value: _isAvaiblable,
                  onChanged: (bool value) {
                    setState(() {
                      _isAvaiblable = value;
                      if (_isAvaiblable) {
                        // getLocation();
                      }
                    });
                  },
                ),
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
              ListTile(
                leading:
                    const Icon(Icons.location_on_outlined, color: primaryColor),
                title: const Text("Utiliser ma position actuelle"),
                trailing: Switch(
                  inactiveTrackColor: Colors.grey,
                  value: _useCurrentLocation,
                  onChanged: (bool value) {
                    setState(() {
                      _useCurrentLocation = value;
                      if (_useCurrentLocation) {
                        getLocation();
                      }
                    });
                  },
                ),
              ),
              const Divider(thickness: 0.5, color: Colors.grey),

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Mes Commandes',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: titleColor),
                ),
              ),
              const SizedBox(height: 8),

              const Divider(thickness: 0.5, color: Colors.grey),
              const SizedBox(height: 8),

              // Slider to select a value between 100 and 5000
              const Center(
                child: Text(
                  'Rayon de livraison',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Slider(
                value: _sliderValue,
                thumbColor: primaryColor,
                inactiveColor: Colors.grey,
                activeColor: primaryColor,
                min: 100,
                max: 6000,
                divisions: 50,
                label: _sliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
              Text(
                'Valeur actuelle: ${_sliderValue / 1000} Km',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Display nearby orders dynamically
              // Display orders or message based on availability status
              _isAvaiblable
                  ? (livreurProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: livreurProvider.nearbyOrders.length,
                          itemBuilder: (context, index) {
                            final order = livreurProvider.nearbyOrders[index];
                            return _buildOrderItem(order);
                          },
                        ))
                  : const Center(
                      child: Text(
                        'Vous êtes actuellement indisponible pour les livraisons.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),

              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    authProvider.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Déconnexion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final restaurantName = order['restaurant']['name'] ?? 'Inconnu';
    // final panierItems = order['panierItems'] as List<dynamic>? ?? [];
    final distance = order['distance'] / 1000;
    final phoneNumber = order['userPhone'];
    print(phoneNumber);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.blueAccent, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Distance : $distance km',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.home, color: Colors.green, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Adresse: ${order['deliveryAddress']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Total Amount

            Row(
              children: [
                const Icon(Icons.restaurant_menu,
                    color: Colors.redAccent, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Restaurant: $restaurantName',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Payment Method
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.blueGrey, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Paiement: ${order['paymentMethod']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.green, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Total: ${order['totalAmount']} DT',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Restaurant Name

            // Basket Items Section
            // const Text(
            //   'Articles dans la commande:',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // const SizedBox(height: 8),

            // // List of items in the order with better spacing
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: panierItems.map<Widget>((item) {
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 4.0),
            //       child: Row(
            //         children: [
            //           const Icon(Icons.fastfood, size: 18, color: Colors.grey),
            //           const SizedBox(width: 4),
            //           Expanded(
            //             child: Text(
            //               '${item['menuItem']['name']} (x${item['quantity']})',
            //               style: const TextStyle(
            //                 fontSize: 14,
            //                 color: Colors.black,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            // ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigation vers la page des détails
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(
                          orderId: order['_id'],
                          distance: distance,
                          phoneNumber: phoneNumber),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Voir les détails de la commande'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
