import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/Commande.dart';
import 'package:foodly_ui/A-providers/commandeprovider.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final double distance;
  final String? phoneNumber;
  const OrderDetailsPage(
      {super.key,
      required this.orderId,
      required this.distance,
      required this.phoneNumber});

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commandeProvider =
          Provider.of<CommandeProvider>(context, listen: false);
      commandeProvider.getOrdersDetails(context, widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commandeProvider = Provider.of<CommandeProvider>(context);

    if (commandeProvider.isLoading) {
      return _loadingIndicator();
    }

    if (commandeProvider.errorMessage != null) {
      return _errorDisplay(commandeProvider.errorMessage!);
    }

    final commande = commandeProvider.commande;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la commande'),
      ),
      body: _buildOrderItem(commande!),
    );
  }

  Widget _loadingIndicator() {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la commande')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _errorDisplay(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la commande')),
      body: Center(child: Text('Erreur: $message')),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final restaurantName = order['restaurant']['name'] ?? 'Inconnu';
    final panierItems = order['panierItems'] as List<dynamic>? ?? [];
    final distance = widget.distance;
    final totalAmount = order['totalAmount'];
    final deliveryAddress = order['deliveryAddress'];
    final status = order['status'];
    final phoneNumber = order['userPhone'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 8,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Commande ID: ${order['_id']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.assignment_turned_in,
                label: 'Statut',
                value: status,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Distance',
                value: '$distance km',
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.restaurant_menu,
                label: 'Restaurant',
                value: restaurantName,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),

              _buildInfoRow(
                icon: Icons.home,
                label: 'Adresse',
                value: deliveryAddress,
                color: Colors.green,
              ),
              const SizedBox(height: 12),

              _buildInfoRow(
                icon: Icons.monetization_on,
                label: 'Total',
                value: '\$$totalAmount',
                color: Colors.green,
              ),
              const SizedBox(height: 12),

              _buildInfoRow(
                icon: Icons.payment,
                label: 'Paiement',
                value: order['paymentMethod'],
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 12),

              const Text(
                'Articles dans la commande:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              _buildInfoRow(
                icon: Icons.phone,
                label: 'Telephone',
                value: widget.phoneNumber!,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 12),
              // List of items in the order with better spacing
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: panierItems.map<Widget>((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.fastfood,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${item['menuItem']['name']} (x${item['quantity']})',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
              const SizedBox(height: 16),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Action to accept or decline the order
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Accepter la commande'),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Action to decline the order
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Refuser la commande'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
