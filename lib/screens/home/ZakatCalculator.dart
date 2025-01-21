import 'package:carousel_slider/carousel_slider.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/ZakatProvider.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/home/DateSpinnerExample.dart';
import 'package:foodly_ui/screens/home/TransactionHistory.dart';
import 'package:provider/provider.dart';

class AddAssetZaketPage extends StatefulWidget {
  const AddAssetZaketPage({super.key});

  @override
  _AddAssetZaketPageState createState() => _AddAssetZaketPageState();
}

class _AddAssetZaketPageState extends State<AddAssetZaketPage> {
  int selectedCard = 0;
  String operation = "ADD";
  String assetType = "GOLD";
  String amount = '';
  String totalGoldValue = '';
  int? amountInInt;
  double goldPricePerGram = 209.0;
  String simpleCalculatorInput = '';
  String simpleCalculatorResult = '';

  final List<String> assetOptions = [
    "CASH",
    "GOLD"
        "SILVER"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Asset Zaket',
          style: TextStyle(color: inputColor),
        ),
        backgroundColor: secondBColor, // Couleur de l'AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCard = 0;
                      });
                    },
                    child: Container(
                      width: 180,
                      height: 90,
                      child: Card(
                        color: selectedCard == 0 ? secondBColor : neutralGray,
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.calculate,
                                color: selectedCard == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Simple Calculator",
                                style: TextStyle(
                                  color: selectedCard == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCard = 1;
                      });
                    },
                    child: Container(
                      width: 180,
                      height: 90,
                      child: Card(
                        color: selectedCard == 1 ? secondBColor : neutralGray,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.wallet,
                                color: selectedCard == 0
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              Text(
                                "Manage  wallet ",
                                style: TextStyle(
                                  color: selectedCard == 1
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Divider(
              //   color: titleColor,
              //   thickness: 0.3,
              //   indent: 5,
              //   endIndent: 5,
              // ),
              // const SizedBox(height: 20),
              if (selectedCard == 0)
                _buildSimpleCalculator()
              else if (selectedCard == 1)
                _buildZakatBalanceManager(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleCalculator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Simple Calculator",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Enter amount in DT",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              simpleCalculatorInput = value;
              double? inputAmount = double.tryParse(value);
              if (inputAmount != null) {
                simpleCalculatorResult = (inputAmount / 40).toStringAsFixed(2);
              } else {
                simpleCalculatorResult = '';
              }
            });
          },
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(color: Colors.green, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10),
              if (simpleCalculatorResult.isNotEmpty)
                Text(
                  "Zakat to pay: $simpleCalculatorResult DT",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Informations sur la zakat
        const Text(
          "Zakat Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    "The total assets (cash and gold) must exceed 13,000 DT to be eligible for zakat.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.orange),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    "The amount must remain unchanged for a full year (one lunar year).",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.green),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    "Zakat rate is 2.5% of the total eligible assets.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildZakatBalanceManager() {
    final zakatProvider = Provider.of<ZakatProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Manage Your Zakat',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: secondaryNavy,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.history, color: primaryColor),
                iconSize: 30,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => TransactionHistory(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          CarouselSlider(
            items: ["CASH", "GOLD", "SILVER", "SALARY"].map((type) {
              final isActive = assetType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    assetType = type;
                    amount = '';
                    totalGoldValue = '';
                    amountInInt = null;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.bounceInOut,
                  width: isActive ? 150 : 140, // Largeur dynamique
                  height: isActive ? 50 : 50, // Hauteur dynamique
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              neutralGray,
                              primaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isActive ? null : neutralGray,
                    borderRadius: BorderRadius.circular(16),
                    border: isActive
                        ? Border.all(color: neutralGray, width: 5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        type,
                        style: TextStyle(
                          color: isActive ? secondaryWhite : Colors.grey[700],
                          fontSize: isActive ? 18 : 16,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 100,
              autoPlay: true,
              enableInfiniteScroll: true,
              viewportFraction: 0.4,
              enlargeCenterPage: true,
              scrollPhysics: const BouncingScrollPhysics(),
            ),
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 0.5,
          ),
          if (assetType == "GOLD")
            _buildInfoTile(
              icon: Icons.info_outline,
              text:
                  "Only gold intended for sale is eligible for Zakat, while gold worn as personal adornment is not.",
            ),
          if (assetType == "CASH")
            _buildInfoTile(
              icon: Icons.info_outline,
              text:
                  "If you have any debts, they should be subtracted from the total cash value before calculating Zakat.",
            ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: operation,
            items: ["ADD", "SUBTRACT"]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                operation = value!;
              });
            },
            decoration: InputDecoration(
              iconColor: secondaryNavy,
              labelText: "Operation",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:
                  assetType == "GOLD" ? "Gold Quantity (grams)" : "Amount (DT)",
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                amount = value;
                amountInInt = int.tryParse(value);

                if (assetType == "GOLD" &&
                    amount.isNotEmpty &&
                    amountInInt != null) {
                  totalGoldValue =
                      (amountInInt! * goldPricePerGram).toStringAsFixed(2);
                }
              });
            },
          ),
          if (assetType == "GOLD" && totalGoldValue.isNotEmpty) ...[
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Text(
                    "Total Gold Value: $totalGoldValue DT",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  Text(
                    "Gold Price Per Gram: $goldPricePerGram DT",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.date_range, color: primaryColor, size: 30),
              const SizedBox(width: 10),
              Text(
                "Select Acquisition Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: secondaryNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(height: 105, child: DateSpinnerExample()),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Validation pour s'assurer que les données sont correctes
              if ((assetType == "GOLD" && amountInInt == null) ||
                  (assetType != "GOLD" &&
                      (amountInInt == null || amountInInt! <= 0))) {
                _showFlashMessage(context, "Please enter a valid amount.",
                    Icons.error, neutralGray);

                return;
              }

              final date = selectedDateNotifier.value;

              final category = assetType;
              final type = operation;
              final double amount = assetType == "GOLD"
                  ? (amountInInt != null ? amountInInt!.toDouble() : 0.0)
                  : (amountInInt != null ? amountInInt!.toDouble() : 0.0);

              // Appeler addTransaction depuis le ZakatProvider
              zakatProvider.AddTransaction(
                  context, type, category, amount, date);

              // Afficher un message de confirmation
              final resultMessage = assetType == "GOLD"
                  ? "Operation: $operation, Type: $assetType, Amount: $amountInInt grams, Total Value: $totalGoldValue DT"
                  : "Operation: $operation, Type: $assetType, Amount: $amountInInt DT";

              _showFlashMessage(
                  context, resultMessage, Icons.check_box, primaryGreen);
              setState(() {
                amountInInt = null;
                selectedDateNotifier.value = "";
                // remettre la date à la valeur initiale
              });
            },
            icon: const Icon(Icons.wallet, size: 20),
            label: const Text('Update Wallet'),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String text}) {
    return ListTile(
      leading: Icon(icon, color: secondaryNavy),
      title: Text(
        text,
        style: const TextStyle(color: secondaryNavy, fontSize: 14),
      ),
    );
  }
}

void _showFlashMessage(
    BuildContext context, String message, IconData icon, Color color) {
  showFlash(
    context: context,
    duration: const Duration(seconds: 3),
    builder: (context, controller) {
      return Flash(
        controller: controller,
        child: FlashBar(
          forwardAnimationCurve: Curves.linear,
          reverseAnimationCurve: Curves.easeIn,
          position: FlashPosition.bottom,
          backgroundColor: color,
          useSafeArea: true,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          icon: Icon(
            icon,
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
