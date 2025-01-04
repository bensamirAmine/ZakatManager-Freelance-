import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
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
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: inputColor, // Fond complètement transparent
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: primaryColor, // Contour noir
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: inputColor.withOpacity(0.2), // Ombre douce
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
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
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }

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
                            await _deleteTransaction(context, transaction.id);
                          },
                          child: Card(
                            color: transaction.type == "ADD"
                                ? backgroundColor
                                : Colors.red.shade50,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                                  color: textColor,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_calendar_outlined,
                                    color: primaryColor),
                                onPressed: () =>
                                    _editTransaction(context, transaction),
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
        ),
      ),
    );
  }

  Future<void> _editTransaction(BuildContext context, transaction) async {
    final amountController =
        TextEditingController(text: transaction.amount.toString());
    String selectedType = transaction.type;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              const Icon(Icons.edit, color: Colors.teal),
              const SizedBox(width: 8),
              const Text(
                "Edit Transaction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Transaction type
                Row(
                  children: [
                    const Icon(Icons.category, color: Colors.teal),
                    const SizedBox(width: 8),
                    Text(
                      "Transaction Type: $selectedType",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    prefixIcon: Icon(
                      transaction.category == "CASH"
                          ? Icons.monetization_on_rounded
                          : Icons.account_balance,
                      color: transaction.category == "CASH"
                          ? primaryColor
                          : Colors.amber,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                // Optional: Add more fields for editing if needed
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedAmount = double.tryParse(amountController.text);
                if (updatedAmount != null) {
                  final zakatProvider =
                      Provider.of<ZakatProvider>(context, listen: false);
                  await zakatProvider.updatetransaction(
                    context,
                    transaction.id,
                    updatedAmount,
                  );
                  Navigator.pop(context);
                } else {
                  // Show a warning if the amount is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid amount."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

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
          color: _selectedSegment == index ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondaryColor, width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: _selectedSegment == index ? inputColor : titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
