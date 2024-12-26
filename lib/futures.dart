// lib/futures.dart
import 'package:flutter/material.dart';
import 'package:healthapp/fitness.dart';
import 'package:healthapp/water_remainder.dart';
import 'package:healthapp/medication.dart';
import 'package:healthapp/nurtition_screen.dart';

class FuturesScreen extends StatelessWidget {
  final List<Map<String, String>> futures = [
  {
    "name": "Exercises",
    "description": "Explore Gym Exercises with Explanation"
  },
  {
    "name": "Water Reminder",
    "description": "Stay hydrated with regular water intake reminders."
  },
  {
    "name": "Supplement Reminder",
    "description": "Never forget to take your supplements with timely reminders."
  },
  {
    "name": "Suggest a Meal",
    "description": "Get meal suggestions based on your preferences and health goals."
  }
];




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: futures.map((future) => FutureCard(future)).toList(),
          ),
        ),
      ),
    );
  }
}

class FutureCard extends StatelessWidget {
  final Map<String, String> future;

  const FutureCard(this.future, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Widget targetScreen;

        switch (future['name']) {
          case 'Exercises':
            targetScreen = const FitnessScreen();
            break;
          case 'Water Reminder':
            targetScreen = const WaterReminder();
            break;
          case 'Supplement Reminder':
            targetScreen = const MedicationAlarmScreen();
            break;

          case 'Suggest a Meal':
            targetScreen = const RecipeScreen();
            break;
          default:
            targetScreen = FuturesScreen();
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                future['name']!,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                future['description']!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


