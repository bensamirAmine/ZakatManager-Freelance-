import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart';
import 'package:foodly_ui/A-providers/commandeprovider.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/home/home_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class CommandeScreen extends StatefulWidget {
  final String restauranId;
  final List<dynamic> orders;
  final double subtotal;
  final int totalAmount;

  const CommandeScreen({
    super.key,
    required this.restauranId,
    required this.subtotal,
    required this.totalAmount,
    required this.orders,
  });

  @override
  _CommandeScreenState createState() => _CommandeScreenState();
}

enum PaymentMethod { Carte, Especes, PayPal }

class _CommandeScreenState extends State<CommandeScreen> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.Especes;
  double latitude = 0;
  double longitude = 0;
  bool _useCurrentLocation = false;
  String _currentAddress = '';
  String _addressOptions = ""; // Liste des adresses basées sur la position
  String _selectedAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final panierProvider =
          Provider.of<PanierProvider>(context, listen: false);
      panierProvider.fetchUserOrdersByRestaurant(context, widget.restauranId);
    });
  }

  void getLocation() async {
    try {
      // Check and request location permissions
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Use the obtained latitude and longitude
      setState(() {
        latitude = position.latitude; // Updating state variables
        longitude = position.longitude;
      });
      // Get address from the coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      setState(() {
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address =
              "${place.street}, ${place.locality}, ${place.country}";

          _addressOptions = address;
          _selectedAddress = _addressOptions;

          // print('Adresse: $address');
          _currentAddress =
              address; // Store current address for other use cases
        } else {
          developer.log('Aucune adresse trouvée pour ces coordonnées.');
        }
      });

      developer.log('Latitude: $latitude, Longitude: $longitude');
    } catch (e) {
      developer.log('Erreur: $e');
    }
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
            backgroundColor: primaryColor,
            useSafeArea: true,
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            icon: const Icon(
              Icons.done_all_outlined,
              color: Colors.black,
            ),
            controller: controller,
            showProgressIndicator: true,
            padding: const EdgeInsets.all(16),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Passage en caisse"),
      ),
      body: Consumer<CommandeProvider>(
        builder: (context, commandeProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text(
                      "Votre commande",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.orders.asMap().entries.map((entry) {
                          int index = entry.key;
                          var order = entry.value;
                          var menuItem = order['menuItem'];

                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${index + 1}. ${menuItem['name']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: titleColor),
                                    ),
                                  ),
                                  const SizedBox(width: defaultPadding),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${menuItem['price']} DT',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Quantité: ${order['quantity']}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Divider(),
                  const Text(
                    "Détails de livraison",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  // Utiliser la position actuelle
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: primaryColor),
                    title: const Text("Utiliser ma position actuelle"),
                    trailing: Switch(
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

                  const SizedBox(height: 10),

                  // Affichage des options d'adresses si la position actuelle est activée
                  if (_useCurrentLocation && _selectedAddress.isNotEmpty)
                    Card(
                      elevation: 5,
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
                              color: primaryColor,
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
                                    _selectedAddress,
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

                  const Divider(),
                  const Text(
                    "Moyen de paiement",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  RadioListTile<PaymentMethod>(
                    title: const Text('Carte bancaire'),
                    value: PaymentMethod.Carte,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    secondary: const Icon(
                      Icons.credit_card,
                      color: primaryColor,
                    ),
                  ),
                  RadioListTile<PaymentMethod>(
                    title: const Text('Especes'),
                    value: PaymentMethod.Especes,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    secondary:
                        const Icon(Icons.attach_money, color: primaryColor),
                  ),
                  RadioListTile<PaymentMethod>(
                    title: const Text('PayPal'),
                    value: PaymentMethod.PayPal,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    secondary: const Icon(Icons.account_balance_wallet,
                        color: primaryColor),
                  ),
                  const Divider(),

                  const Text(
                    "Récapitulatif",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ListTile(
                    title: const Text("Produits"),
                    trailing: Text("${widget.subtotal.toStringAsFixed(2)} DT"),
                  ),
                  const ListTile(
                    title: Text("Livraison"),
                    trailing: Text("GRATUIT"),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "TOTAL",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text("${widget.subtotal.toStringAsFixed(2)} DT"),
                  ),

                  // Bouton de validation
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Définir la méthode de paiement en texte
                      String paymentMethodText;
                      switch (_selectedPaymentMethod) {
                        case PaymentMethod.Carte:
                          paymentMethodText = 'Carte bancaire';
                          break;
                        case PaymentMethod.Especes:
                          paymentMethodText = 'Especes';
                          break;
                        case PaymentMethod.PayPal:
                          paymentMethodText = 'PayPal';
                          break;
                        default:
                          paymentMethodText = 'Especes';
                      }

                      // Confirmer la commande
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Moyen de paiement sélectionné"),
                            content:
                                Text("Vous avez choisi : $paymentMethodText"),
                            actions: [
                              TextButton(
                                child: const Text("Non"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                  child: const Text("Oui"),
                                  onPressed: () {
                                    commandeProvider.setCommande(
                                        context,
                                        widget.restauranId,
                                        widget.orders,
                                        latitude,
                                        longitude,
                                        _currentAddress,
                                        paymentMethodText,
                                        widget.totalAmount,
                                        widget.subtotal);
                                    _showFlashMessage(context,
                                        commandeProvider.message.toString());
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                    );
                                  }
                                  // Navigator.of(context).pop();

                                  ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "VALIDER",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
