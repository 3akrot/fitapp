// lib/Fitness_Page.dart
import 'package:flutter/material.dart';

class FitnessPage extends StatelessWidget {
  const FitnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
    title: const Text(
      'Healthy Lifestyle',
      style: TextStyle(
        color: Colors.white, // Set text color to white
      ),
    ),
    backgroundColor: const Color(0xFF5e4e8f),
    iconTheme: const IconThemeData(
      color: Colors.white, // Set back arrow color to white
    ),
  ),
      body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/healthylifestyle.jpg',
                height: 250, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // First pair of buttons
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to sport page
                  Navigator.pushNamed(context, '/fitness');

                },
                icon: const Icon(Icons.sports_soccer, color: Colors.white),
                label: const Text(
                  'Sport',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5e4e8f),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(130, 150),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to nutrition page
                  Navigator.pushNamed(context, '/nutrition');
                },
                icon: const Icon(Icons.local_dining, color: Colors.white),
                label: const Text(
                  'Nutrition',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5e4e8f),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(130, 150),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Add space between the rows of buttons and the text
          const Text(
            'Unlock your fitness\nSUPERPOWERS!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFee9e57),
            ),
          ),
          const SizedBox(height: 10), // Add space between the text and the next row of buttons
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Second pair of buttons
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to water page
                  Navigator.pushNamed(context, '/water');

                  },
                  icon: const Icon(Icons.local_drink, color: Colors.white),
                  label: const Text(
                    'Water',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5e4e8f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(130, 150),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to sleep page
                    Navigator.pushNamed(context, '/sleep');

                  },
                  icon: const Icon(Icons.bedtime, color: Colors.white),
                  label: const Text(
                    'Sleep',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5e4e8f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(130, 150),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),);
  }
}
