import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart';
import 'package:foodly_ui/A-utils/ApiEndpoints.dart';
import 'package:provider/provider.dart';
import 'package:foodly_ui/A-providers/SupplementProvider.dart';
import 'package:foodly_ui/constants.dart';

class SupplementSelectionDialog extends StatefulWidget {
  final String menuItemId;
  final String restaurantId;
  final int quantity;

  const SupplementSelectionDialog({
    Key? key,
    required this.menuItemId,
    required this.restaurantId,
    required this.quantity,
  }) : super(key: key);

  @override
  _SupplementSelectionDialogState createState() => _SupplementSelectionDialogState();
}

class _SupplementSelectionDialogState extends State<SupplementSelectionDialog> {
  List<String> selectedSupplements = []; // Liste des suppléments sélectionnés

  void _toggleSupplement(String supplementId, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedSupplements.add(supplementId);
      } else {
        selectedSupplements.remove(supplementId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final supplementProvider = Provider.of<SupplementProvider>(context);

    return AlertDialog(
      title: const Text('Sélectionnez des suppléments'),
      content: SingleChildScrollView( // Permet de faire défiler le contenu
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: supplementProvider.getAllSuplements(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Erreur lors du chargement des suppléments"));
                } else {
                  return ListView.builder(
                    itemCount: supplementProvider.supplements.length,
                    shrinkWrap: true, // Important pour un ListView dans un SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(), // Empêche le scroll de ListView
                    itemBuilder: (context, index) {
                      final supplement = supplementProvider.supplements[index];
                      final isSelected = selectedSupplements.contains(supplement['_id']);
                      const String baseUrl = ApiEndpoints.ImagesupplementURL;
                      final String imageUrl = "$baseUrl${supplement['image']}";

                      return ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(supplement['name']),
                        subtitle: Text('Prix: ${supplement['price'].toString()} €'),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            _toggleSupplement(supplement['_id'], value ?? false);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final menuProvider = Provider.of<PanierProvider>(context, listen: false);
            menuProvider.addItemToPanier(
              context,
              widget.menuItemId,
              widget.restaurantId,
              widget.quantity.toString(),
              selectedSupplements,
            );
            Navigator.pop(context); // Ferme le dialog
          },
          child: const Text('Ajouter au panier'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Ferme le dialog sans ajouter
          },
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
