// lib/datetime_series_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:healthapp/database.dart';
import 'package:healthapp/food_track_entry.dart';
class DateTimeChart extends StatefulWidget {
  const DateTimeChart({super.key});

  @override
  _DateTimeChart createState() => _DateTimeChart();
}
class _DateTimeChart extends State<DateTimeChart> {
  List<FlSpot> resultChartData = [];
  DatabaseService databaseService = DatabaseService(
    uid: "fitapp-84a14",
    currentDate: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    getAllFoodTrackData();
  }

  void getAllFoodTrackData() async {
    List<dynamic> foodTrackResults = await databaseService.getAllFoodTrackData();
    List<FoodTrackEntry> foodTrackEntries = [];
    for (var foodTrack in foodTrackResults) {
      if (foodTrack["createdOn"] != null) {
        foodTrackEntries.add(FoodTrackEntry(
          foodTrack["createdOn"].toDate(),
          foodTrack["calories"],
        ));
      }
    }
    populateChartWithEntries(foodTrackEntries);
  }

  void populateChartWithEntries(List<FoodTrackEntry> foodTrackEntries) {
    Map<String, int> caloriesByDateMap = {};
    var dateFormat = DateFormat("yyyy-MM-dd");

    for (var foodEntry in foodTrackEntries) {
      var trackedDateStr = dateFormat.format(foodEntry.date);
      if (caloriesByDateMap.containsKey(trackedDateStr)) {
        caloriesByDateMap[trackedDateStr] =
            caloriesByDateMap[trackedDateStr]! + foodEntry.calories;
      } else {
        caloriesByDateMap[trackedDateStr] = foodEntry.calories;
      }
    }

    List<FoodTrackEntry> caloriesByDateTimeMap = [];
    for (var foodEntry in caloriesByDateMap.keys) {
      DateTime entryDateTime = DateTime.parse(foodEntry);
      caloriesByDateTimeMap.add(FoodTrackEntry(
        entryDateTime,
        caloriesByDateMap[foodEntry]!,
      ));
    }

    caloriesByDateTimeMap.sort((a, b) =>
        a.date.microsecondsSinceEpoch.compareTo(b.date.microsecondsSinceEpoch));

    setState(() {
      resultChartData = caloriesByDateTimeMap
          .map((entry) =>
              FlSpot(entry.date.millisecondsSinceEpoch.toDouble(), entry.calories.toDouble()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (resultChartData.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Caloric Intake By Date Chart"),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  height: 500.0,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: resultChartData,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              DateTime date =
                                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
                              return Text(DateFormat("MM/dd").format(date));
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}