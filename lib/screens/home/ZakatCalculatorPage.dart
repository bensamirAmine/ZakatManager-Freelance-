import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/home/ZakatCalculator.dart';

class ZakatCalculator extends StatefulWidget {
  @override
  _ZakatCalculatorState createState() => _ZakatCalculatorState();
}

class _ZakatCalculatorState extends State<ZakatCalculator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  double grammePrice = 209.0;
  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation for a loop
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.6 + 0.4 * _animationController.value,
                        child: child,
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColor,
                      child: Icon(
                        FontAwesomeIcons.handHoldingHeart,
                        color: inputColor,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "Zakat Assets Manager",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: primaryColor,
                      size: 30,
                    ),
                    onPressed: () {
                      // _showAddDetailsPopup(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAssetZaketPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Manage your Zakat details here",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//   void _showAddDetailsPopup(BuildContext context) {
//     String operation = "ADD";
//     String type = "CASH";
//     String amount = ""; // amount est initialement une chaîne vide
//     int?
//         amountInInt; // Déclare une variable pour stocker la valeur convertie en int
//     String totalGoldValue = "";

//     // Chaîne contenant le prix du gramme d'or
//     String goldPriceString = "209 DT"; // Par exemple "209 د.ج"

//     // Extraire le prix du gramme d'or de la chaîne
//     double goldPricePerGram = 0.0;

//     // Tenter de récupérer la partie numérique de la chaîne
//     try {
//       goldPricePerGram = double.parse(goldPriceString.split(" ")[0]);
//     } catch (e) {
//       print("Erreur lors de l'extraction du prix de l'or : $e");
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Manage Zakat Balance"),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   DropdownButtonFormField<String>(
//                     value: operation,
//                     items: ["ADD", "SUBTRACT"]
//                         .map((e) => DropdownMenuItem(
//                               value: e,
//                               child: Text(e),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         operation = value!;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Operation",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   DropdownButtonFormField<String>(
//                     value: type,
//                     items: ["CASH", "GOLD"]
//                         .map((e) => DropdownMenuItem(
//                               value: e,
//                               child: Text(e),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         type = value!;
//                         // Réinitialisation du champ de l'or lorsque le type change
//                         amount = "";
//                         totalGoldValue = "";
//                         amountInInt =
//                             null; // Réinitialiser la variable amountInInt
//                       });
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Type",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText:
//                           type == "GOLD" ? "Gold Quantity (grams)" : "Amount",
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         amount = value;
//                         // Conversion de 'amount' en int (si possible)
//                         amountInInt = int.tryParse(value);

//                         if (type == "GOLD" &&
//                             amount.isNotEmpty &&
//                             amountInInt != null) {
//                           // Calcul du total pour l'or
//                           totalGoldValue = (amountInInt! * goldPricePerGram)
//                               .toStringAsFixed(2); // Le résultat en dinars
//                         }
//                       });
//                     },
//                   ),
//                   if (type == "GOLD" && totalGoldValue.isNotEmpty) ...[
//                     const SizedBox(height: 10),
//                     Column(
//                       children: [
//                         Text(
//                           "Total Gold Value:  $totalGoldValue DT",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           " Gold Price Per Gram:  $goldPricePerGram DT",
//                           style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ],
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (type == "GOLD" && totalGoldValue.isNotEmpty) {
//                   print(
//                       "Operation: $operation, Type: $type, Total Value: د.ج $totalGoldValue");
//                 } else {
//                   print(
//                       "Operation: $operation, Type: $type, Amount: $amountInInt");
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: Text("Submit"),
//             ),
//           ],
//         );
//       },
//     );
//   }
}
