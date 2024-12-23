import 'package:flutter/material.dart';
import 'package:foodly_ui/A-models/UserModel.dart';

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
      children: [
        _progressBar(
          "Balance",
          balancePercentage,
          Colors.blue,
        ),
        const SizedBox(height: 10),
        _progressBar(
          "Gold",
          goldPercentage,
          Colors.amber,
        ),
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
              style: TextStyle(
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
}
