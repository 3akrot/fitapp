// lib/screens/homepage.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = true;
  bool _hasWorkoutPlan = false;
  Map<String, dynamic>? _workoutPlanData;

  @override
  void initState() {
    super.initState();
    _checkWorkoutPlan();
  }

  Future<void> _checkWorkoutPlan() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null && doc.data()!['workoutPlan'] != null) {
        setState(() {
          _hasWorkoutPlan = true;
          _workoutPlanData = doc.data();
        });
      } else {
        await _generateWorkoutPlan();
      }
    } catch (e) {
      print('Error checking workout plan: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _generateWorkoutPlan() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final userDoc = await _firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      final level = data?['level'] ?? 'beginner';

      // Example: Generate a workout plan based on the user's level
      final workoutPlan = {
        'Monday': ['Push-ups', 'Plank'],
        'Tuesday': ['Squats', 'Lunges'],
        'Wednesday': ['Rest'],
        'Thursday': ['Jump Rope', 'Burpees'],
        'Friday': ['Yoga'],
        'Saturday': ['Jogging'],
        'Sunday': ['Rest'],
      };

      await _firestore.collection('users').doc(userId).set({
        ...data ?? {},
        'workoutPlan': workoutPlan,
      });

      setState(() {
        _workoutPlanData = {
          ...data!,
          'workoutPlan': workoutPlan,
        };
        _hasWorkoutPlan = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Plan')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _hasWorkoutPlan
              ? _buildWorkoutPlanView()
              : Center(
                  child: ElevatedButton(
                    onPressed: _generateWorkoutPlan,
                    child: Text('Generate Workout Plan'),
                  ),
                ),
    );
  }

 Widget _buildWorkoutPlanView() {
  final workoutPlan = _workoutPlanData?['workoutPlan'] as Map<String, dynamic>? ?? {};

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Your Workout Plan Preview:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: ListView(
          children: workoutPlan.entries.map((entry) {
            final day = entry.key;
            final exercises = entry.value is List<dynamic>
                ? entry.value as List<dynamic>
                : ['Invalid data'];
            return ListTile(
              title: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(exercises.join(', ')),
            );
          }).toList(),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildTodayWorkoutDialog(),
          );
        },
        child: Text('Show Today\'s Workout'),
      ),
    ],
  );
}


  Widget _buildTodayWorkoutDialog() {
    final today = DateTime.now().weekday;
    final dayName = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][today - 1];

    final workoutPlan = _workoutPlanData?['workoutPlan'] ?? {};
    final todayExercises = workoutPlan[dayName] ?? ['Rest'];

    return AlertDialog(
      title: Text('Today\'s Workout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: todayExercises.map((exercise) => Text(exercise)).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}
