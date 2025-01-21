import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/RestaurantProvider.dart';
import 'package:provider/provider.dart';
import '../../components/buttons/primary_button.dart';
import '../../constants.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart'; // Assurez-vous que ce chemin est correct

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the orders when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PanierProvider>(context, listen: false)
          .fetchUserOrders(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: Consumer<PanierProvider>(
        builder: (context, panierProvider, child) {
          if (panierProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // if (panierProvider.errorMessage != null) {
          //   return Center(child: Text(panierProvider.errorMessage!));
          // }

          final orders = panierProvider.orders;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding),
                  // List of fetched orders
                  if (orders.isNotEmpty) ...[
                    ...List.generate(
                      orders.length,
                      (index) {
                        final itemId = orders[index]['_id'];

                        final retaurantID = orders[index]['restaurant'];
                        // Fetch the restaurant using its ID

                        // print(restaurantname);
                        final menuItem = orders[index]["menuItem"];

                        final name = menuItem["name"] ?? "No name";
                        // final description = "";
                        final quantity = orders[index]["quantity"] ?? 1;
                        final price = (menuItem["price"] != null)
                            ? menuItem["price"].toDouble()
                            : 0.0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding / 2),
                          child: OrderedItemCard(
                            name: name,
                            description: "",
                            quantity: quantity,
                            price: price,
                            onDismissed: () {
                              panierProvider.deleteItem(
                                  context, itemId, retaurantID);
                            },
                            onUpdate: (newQuantity) {
                              panierProvider.updateItem(
                                  context, itemId, newQuantity);
                            },
                          ),
                        );
                      },
                    ),
                  ] else if (orders.isEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centrer verticalement
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Image.asset(
                                    "assets/images/noorder.png",
                                    width: MediaQuery.of(context).size.width *
                                        0.6, // Ajuster la largeur
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                ],
                // const PriceRow(text: "Subtotal", price: 28.0),
                // const SizedBox(height: defaultPadding / 2),
                // const PriceRow(text: "Delivery", price: 0),
                // const SizedBox(height: defaultPadding / 2),
                // const TotalPrice(price: 20),
                // const SizedBox(height: defaultPadding * 2),
                // PrimaryButton(
                //   text: "Checkout (\$20.10)",
                //   press: () {},
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}
