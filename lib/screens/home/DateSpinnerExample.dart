import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Créez un ValueNotifier pour partager l'état
final ValueNotifier<String> selectedDateNotifier =
    ValueNotifier<String>("2024-12-01");

class DateSpinnerExample extends StatefulWidget {
  @override
  _DateSpinnerExampleState createState() => _DateSpinnerExampleState();
}

class _DateSpinnerExampleState extends State<DateSpinnerExample> {
  int _selectedYear = 2024;
  int _selectedMonth = 12;
  int _selectedDay = 1;

  List<int> years = List.generate(100, (index) => 2020 + index);
  List<int> months = List.generate(12, (index) => index + 1);
  List<int> days = List.generate(31, (index) => index + 1);

  // Fonction pour mettre à jour le ValueNotifier
  void updateSelectedDate() {
    final date =
        "${_selectedYear.toString().padLeft(4, '0')}-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}";
    selectedDateNotifier.value = date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Sélecteur d'année
                        SizedBox(
                          width: 80,
                          child: CupertinoPicker(
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                _selectedYear = years[index];
                                updateSelectedDate();
                              });
                            },
                            children: years
                                .map((year) => Text(year.toString()))
                                .toList(),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Sélecteur de mois
                        SizedBox(
                          width: 70,
                          child: CupertinoPicker(
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                _selectedMonth = months[index];
                                updateSelectedDate();
                              });
                            },
                            children: months
                                .map((month) => Text(month.toString()))
                                .toList(),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Sélecteur de jour
                        SizedBox(
                          width: 60,
                          child: CupertinoPicker(
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                _selectedDay = days[index];
                                updateSelectedDate();
                              });
                            },
                            children: days
                                .map((day) => Text(day.toString()))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    ValueListenableBuilder<String>(
                      valueListenable: selectedDateNotifier,
                      builder: (context, value, child) {
                        return Text(
                          "Selected Date: $value",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
