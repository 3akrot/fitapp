// lib/profile.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget {
  final User? user; // Pass the User object

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? workoutPlan;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.user?.uid).get();

      if (userSnapshot.exists) {
        setState(() {
          userData = userSnapshot.data() as Map<String, dynamic>;
          workoutPlan = userData?['workoutPlan'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null || workoutPlan == null) {
      return Scaffold(

        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Profile"),
                 // Add space between Text and IconButton
                IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareProfile,
                ),
              ],
              ),
              _buildUserDetailsSection(),
              const SizedBox(height: 30),
              _buildWorkoutPlanSection(),
            ],
          ),
        ),
      ),
    );
  }

  void _shareProfile() {
    final userName = userData?['username'] ?? 'Unknown User';
    final userEmail = userData?['email'] ?? 'No Email';
    final message = 'Check out my workout plan and profile: \n$userName \nEmail: $userEmail';

    Share.share(message);
  }

  Widget _buildUserDetailsSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Username:', userData?['username']),
            _buildDetailRow('Email:', userData?['email']),
            _buildDetailRow('Height:', '${userData?['height']} cm'),
            _buildDetailRow('Weight:', '${userData?['weight']} kg'),
            _buildDetailRow('Age:', userData?['age']),
            _buildDetailRow('BMI:', userData?['bmi'].toStringAsFixed(1)),
            _buildDetailRow('Fitness Goal:', userData?['goal']),
            _buildDetailRow('Fitness Level:', userData?['level']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPlanSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggested Workout Plan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            for (int i = 1; i <= 4; i++) _buildWeekWorkout(i),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekWorkout(int week) {
    var weekWorkouts = workoutPlan?['Week $week'] ?? {};
    if (weekWorkouts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Week $week',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (var exercise in weekWorkouts.keys)
            _buildExerciseRow(exercise, weekWorkouts[exercise]),
        ],
      ),
    );
  }

  Widget _buildExerciseRow(String exercise, Map<String, dynamic> setsReps) {
    int sets = setsReps['sets'] ?? 0;
    int reps = setsReps['reps'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$exercise:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Text(
            '$sets sets x $reps reps',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
