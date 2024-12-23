import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodly_ui/A-providers/ZakatProvider.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  int _selectedSegment = 0;

  @override
  void initState() {
    super.initState();
    final zakatProvider = Provider.of<ZakatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      zakatProvider.recalculateTotals(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSegmentButton("Cash", 0),
                const SizedBox(width: 12),
                _buildSegmentButton("Gold", 1),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ZakatProvider>(
              builder: (context, zakatProvider, child) {
                if (zakatProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (zakatProvider.errorMessage != null) {
                  return Center(
                    child: Text(
                      zakatProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                // Filtrer les transactions en fonction de _selectedSegment
                final transactions = _selectedSegment == 0
                    ? zakatProvider.history
                        .where((tx) => tx.category == "CASH")
                        .toList()
                    : zakatProvider.history
                        .where((tx) => tx.category == "GOLD")
                        .toList();

                if (transactions.isEmpty) {
                  return const Center(
                    child: Text("No transactions available."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    // Utilisation de Dismissible
                    return Dismissible(
                      key: Key(transaction.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) async {
                        // Appeler la méthode deleteTransaction
                        await _deleteTransaction(context, transaction.id);
                      },
                      child: Card(
                        color: transaction.type == "ADD"
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: transaction.type == "ADD"
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                            child: Icon(
                              transaction.type == "ADD"
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: transaction.type == "ADD"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(
                            "${transaction.type} - ${transaction.amount} ${_selectedSegment == 0 ? "DT" : "g"}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Date: ${transaction.acquisitionDate}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour supprimer une transaction
  Future<void> _deleteTransaction(
      BuildContext context, String transactionId) async {
    final zakatProvider = Provider.of<ZakatProvider>(context, listen: false);
    try {
      await zakatProvider.deleteTransaction(context, transactionId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaction deleted successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete transaction: $e")),
      );
    }
  }

  // Bouton pour changer de segment
  Widget _buildSegmentButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSegment = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color:
              _selectedSegment == index ? Colors.teal.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.teal.shade700, width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color:
                _selectedSegment == index ? Colors.white : Colors.teal.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
