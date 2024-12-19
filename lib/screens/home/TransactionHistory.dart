import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:provider/provider.dart';
import 'package:foodly_ui/A-providers/ZakatProvider.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  int _selectedSegment = 0; // 0 for Cash, 1 for Gold

  @override
  void initState() {
    super.initState();
    // Charger les totaux et l'historique au démarrage
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
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              color: primaryColor,
              height: 50,
              child: Center(
                child: Text(
                  'Transaction History',
                  style: TextStyle(
                      color: inputColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
              ),
            ),
          ),
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

          // Transactions List with Consumer
          Expanded(
            child: Consumer<ZakatProvider>(
              builder: (context, zakatProvider, child) {
                if (zakatProvider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                  );
                }

                if (zakatProvider.errorMessage != null) {
                  return Center(
                    child: Text(
                      zakatProvider.errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                // Filter transactions based on the selected segment
                final transactions = _selectedSegment == 0
                    ? zakatProvider.history
                        .where((tx) => tx.category == "CASH")
                        .toList()
                    : zakatProvider.history
                        .where((tx) => tx.category == "GOLD")
                        .toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      color: transaction.type == "ADD"
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                          style: TextStyle(
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

  // Button for switching segments
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
          borderRadius: BorderRadius.circular(30),
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
