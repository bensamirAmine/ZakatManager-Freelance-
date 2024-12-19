import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart';
import 'package:foodly_ui/screens/details/components/SupplementSelection.dart';
import 'package:provider/provider.dart';

class AskForSupplementsPage extends StatefulWidget {
  final String menuItemId;
  final String restaurantId;
  final int quantity;

  const AskForSupplementsPage({
    Key? key,
    required this.menuItemId,
    required this.restaurantId,
    required this.quantity,
  }) : super(key: key);

  @override
  _AskForSupplementsPageState createState() => _AskForSupplementsPageState();
}

class _AskForSupplementsPageState extends State<AskForSupplementsPage> {
  List<String> selectedSupplements =
      []; // Liste pour les suppléments sélectionnés
  late PanierProvider panierProvider; // Déclarez le PanierProvider ici

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Récupérer le PanierProvider ici
    panierProvider = Provider.of<PanierProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _askForSupplements(context),
          child: const Text('Passer au panier'),
        ),
      ),
    );
  }

  void _askForSupplements(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Souhaitez-vous ajouter des suppléments ?'),
          content: const Text(
              'Voulez-vous ajouter des suppléments à votre commande ?'),
          actions: [
            TextButton(
              onPressed: () {
                // Fermer la boîte de dialogue
                Navigator.of(context).pop();

                // Naviguer vers la page des suppléments
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupplementSelectionDialog(
                            menuItemId: widget.menuItemId,
                            restaurantId: widget.restaurantId,
                            quantity: widget.quantity,
                          )),
                );
              },
              child: Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                // Fermer la boîte de dialogue
                Navigator.of(context).pop();

                // Appeler le PanierProvider pour passer le panier
                panierProvider.addItemToPanier(
                  context,
                  widget.menuItemId,
                  widget.restaurantId,
                  widget.quantity.toString(),
                  selectedSupplements, // Utilisez les suppléments sélectionnés
                );
              },
              child: Text('Non'),
            ),
          ],
        );
      },
    );
  }
}
