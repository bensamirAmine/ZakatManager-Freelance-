import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/screens/Commande/CommandePage.dart';
import 'package:foodly_ui/screens/onboarding/onboarding_scrreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../components/buttons/primary_button.dart';
import '../../constants.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart'; // Assurez-vous que ce chemin est correct
import 'dart:developer' as developer;

// ignore: camel_case_types
class OrderDetailsByRestaurantScreen extends StatefulWidget {
  final String restaurantId;

  const OrderDetailsByRestaurantScreen({super.key, required this.restaurantId});

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsByRestaurantScreenState createState() =>
      _OrderDetailsByRestaurantScreenState();
}

class _OrderDetailsByRestaurantScreenState
    extends State<OrderDetailsByRestaurantScreen> {
  @override
  void initState() {
    super.initState();
    // Clear the orders list and fetch new orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final panierProvider =
          Provider.of<PanierProvider>(context, listen: false);
      // panierProvider.ordersbyrestaurant = []; // Clear previous orders
      panierProvider.fetchUserOrdersByRestaurant(context, widget.restaurantId);
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
            backgroundColor: primaryColor,
            useSafeArea: true,
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.black, // Message text color
                fontSize: 16, // Font size of the message
              ),
            ),
            icon: const Icon(
              Icons.shopping_cart_outlined, // Optional icon
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
      ),
      body: Consumer<PanierProvider>(
        builder: (context, panierProvider, child) {
          if (panierProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          double subtotal = 0.0;
          final orders = panierProvider.ordersbyrestaurant;
          developer.log("orders: ${(orders)}", name: 'checkmenulikes');
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding),
                  if (orders.isNotEmpty) ...[
                    ...List.generate(
                      orders.length,
                      (index) {
                        final itemId = orders[index]['_id'];
                        final menuItem = orders[index]["menuItem"];
                        final name = menuItem["name"] ?? "No name";
                        final description = menuItem["description"] ??
                            "No description available";
                        final quantity = orders[index]["quantity"] ?? 1;
                        final price = (menuItem["price"] != null)
                            ? menuItem["price"].toDouble()
                            : 0.0;
                        subtotal += quantity * price;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding / 2),
                          child: OrderedItemCard(
                            name: name,
                            description: description,
                            quantity: quantity,
                            price: price,
                            onDismissed: () {
                              panierProvider.deleteItem(
                                  context, itemId, widget.restaurantId);
                            },
                            onUpdate: (newQuantity) {
                              panierProvider.updateItem(
                                  context, itemId, newQuantity);
                            },
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    const Text("No orders found."),
                  ],
                  PriceRow(text: "Subtotal", price: subtotal),
                  const SizedBox(height: defaultPadding / 2),
                  PriceRow(text: "Delivery", price: (subtotal * 10) / 100),
                  const SizedBox(height: defaultPadding / 2),
                  TotalPrice(price: subtotal + ((subtotal * 10) / 100)),
                  const SizedBox(height: defaultPadding * 2),
                  PrimaryButton(
                    text: "\$${subtotal + ((subtotal * 10) / 100)}",
                    press: () {
                      final total = subtotal + ((subtotal * 10) / 100);
                      final count = orders.length;
                      developer.log(count.toString(),
                          name: 'commandeService.setCommande');
                      developer.log(widget.restaurantId,
                          name: 'commandeService.setCommande');
                      developer.log(orders.toString(),
                          name: 'commandeService.setCommande');
                      developer.log(orders.toString(),
                          name: 'commandeService.setCommande');
                      developer.log(total.toString(),
                          name: 'commandeService.setCommande');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommandeScreen(
                            totalAmount: orders.length,
                            restauranId: widget.restaurantId,
                            subtotal: total,
                            orders: orders,
                          ),
                        ),
                      );
                    },
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
/*
developer.log("subtotal: ${widget.subtotal}",
                                    name: 'commandeProvider');

                                developer.log("res :${widget.restauranId}",
                                    name: 'commandeProvider');

                                developer.log("orders: ${widget.orders}",
                                    name: 'commandeProvider');

                                developer.log("amount :${widget.totalAmount}",
                                    name: 'commandeProvider');

                                developer.log("latitude$latitude",
                                    name: 'commandeProvider');

                                developer.log("long: $longitude",
                                    name: 'commandeProvider');
                                developer.log(
                                    "_currentAddress: $_currentAddress",
                                    name: 'commandeProvider');
                                developer.log(
                                    "paymentMethodText   : $paymentMethodText",
                                    name: 'commandeProvider');
                                commandeProvider.setCommande(
                                    context,
                                    widget.restauranId,
                                    widget.orders,
                                    latitude,
                                    longitude,
                                    "Tunis",
                                    paymentMethodText,
                                    widget.totalAmount,
                                    widget.subtotal);
                                // Navigator.of(context).pop();
                              },
*/