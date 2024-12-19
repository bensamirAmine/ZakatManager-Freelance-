import 'package:flutter/material.dart';

class ZakatCard extends StatelessWidget {
  final DateTime zakatDueDate;
  final double zakatAmount;
  final String Function(DateTime) calculateRemainingTime;

  const ZakatCard({
    Key? key,
    required this.zakatDueDate,
    required this.zakatAmount,
    required this.calculateRemainingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5, // Ombre pour la carte
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Bords arrondis
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding interne
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligner à gauche
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today, // Icône calendrier
                    color: Colors.green,
                    size: 30,
                  ),
                  SizedBox(width: 8), // Espacement entre l'icône et le texte
                  Text(
                    "Votre Zakat sera due le ${zakatDueDate.day}-${zakatDueDate.month}-${zakatDueDate.year}.",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8), // Espacement vertical
              Text(
                calculateRemainingTime(zakatDueDate),
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8), // Espacement vertical
              Text(
                "Total à payer = ${zakatAmount / 40} DT",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
