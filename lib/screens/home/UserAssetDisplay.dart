import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Pour le graphique circulaire
import 'package:foodly_ui/A-models/UserModel.dart';
import 'package:foodly_ui/constants.dart';

class UserAssetDisplay extends StatelessWidget {
  final User user;

  const UserAssetDisplay({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcul du total et des pourcentages
    double totalValue = (user.balance ?? 0.0) +
        ((user.goldWeight ?? 0.0) * (user.goldPricePerGram ?? 0.0));

    double balancePercentage =
        totalValue > 0 ? (user.balance ?? 0.0) / totalValue : 0.0;
    double goldPercentage = totalValue > 0
        ? ((user.goldWeight ?? 0.0) * (user.goldPricePerGram ?? 0.0)) /
            totalValue
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Text(
            "Chaque contribution ouvre des portes et allège des cœurs Mesurez votre impact"),
        const SizedBox(
          height: 15,
        ),
        // Barres de progression pour Balance et Gold

        _progressBar(
          "Cash",
          balancePercentage,
          textColor,
        ),
        const SizedBox(height: 20),
        _progressBar(
          "Gold",
          goldPercentage,
          thirdColor,
        ),
        const SizedBox(height: 20),

        // Affichage supplémentaire si l'utilisateur doit payer la zakat
        if (user.zakatCalculated == true) ...[
          // const Text(
          //   "Metrics",
          //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 10),
          // Text(
          //   "Date de la zakat : ${user.NissabAcquisitionDate}",
          //   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          // ),
          // const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 200,
              child: _pieChart(user),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _legendItem(
                "Cash",
                accentColor,
              ),
              _legendItem("Gold", primaryGold),
              _legendItem("Silver", Colors.grey),
            ],
          )
        ],
      ],
    );
  }

  Widget _progressBar(String label, double? progress, Color color) {
    double displayProgress =
        (progress != null && progress >= 0.0 && progress <= 1.0)
            ? progress
            : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Text(
              "${(displayProgress * 100).toStringAsFixed(1)}%", // Affichage du pourcentage
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth * (progress ?? 0),
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pieChart(User user) {
    double totalValue = (user.balance ?? 0.0) +
        ((user.goldWeight ?? 0.0) * (user.goldPricePerGram ?? 0.0));
    double goldPercentage = totalValue > 0
        ? ((user.goldWeight ?? 0.0) * (user.goldPricePerGram ?? 0.0))
        : 0.0;
    double balancePercentage =
        totalValue > 0 ? totalValue - goldPercentage : 0.0;

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: balancePercentage,
            color: textColor,
            title: "",
            titleStyle: const TextStyle(fontSize: 0, color: Colors.white),
          ),
          PieChartSectionData(
            value: goldPercentage,
            color: thirdColor,
            title: "",
            titleStyle: const TextStyle(fontSize: 0, color: Colors.white),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}

Widget _legendItem(String title, Color color) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 5),
      Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    ],
  );
}
