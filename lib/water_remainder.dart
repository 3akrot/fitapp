import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterReminder extends StatefulWidget {
  const WaterReminder({super.key});

  @override
  _WaterReminderState createState() => _WaterReminderState();
}

class _WaterReminderState extends State<WaterReminder> {
  double _currentIntake = 0.0;
  final double _dailyGoal = 2500.0;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadCurrentIntake();
  }

  void _loadCurrentIntake() async {
    _user = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firestore.collection('waterIntake').doc(_user.uid).get();
    if (snapshot.exists) {
      setState(() {
        _currentIntake = snapshot['currentIntake'] ?? 0.0;
      });
    }
  }

  void _saveCurrentIntake() async {
    await _firestore.collection('waterIntake').doc(_user.uid).set({
      'currentIntake': _currentIntake,
    });
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _logWaterIntake(double amount) {
    if (_currentIntake + amount >= _dailyGoal) {
      _currentIntake = _dailyGoal;
      _showGoalReachedAlert();
    } else {
      setState(() {
        _currentIntake += amount;
      });
      _scheduleNotification();
    }
    _saveCurrentIntake();
  }

  void _showGoalReachedAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have reached your daily water intake goal!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _scheduleNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Water Reminder',
      'Time to drink water!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  void dispose() {
    _currentIntake = 0.0; // Reset the progress when the page is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _currentIntake / _dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Water Reminder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1f0825),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1f0825),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0), // Add padding between app bar and image
        child: Stack(
          children: [
            Positioned(
              top: 0, // Position at the top of the screen
              left: 70, // Adjust the left padding
              right: 70, // Center horizontally
              child: Image.asset(
                "assets/glass2.jpg", // Check the path to your image
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 150, // Adjust the width of the image
                height: 300, // Adjust the height of the image
              ),
            ),
            Positioned(
              top: 310, // Position the container below the image
              left: 30, // Adjust the left padding
              right: 30, // Adjust the right padding
              child: Container(
                width: MediaQuery.of(context).size.width - 100, // Adjust the width of the container to fill the screen width with padding
                height: 500, // Adjust the height of the container
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 36.0),
                      child: Text(
                        '${_currentIntake.toStringAsFixed(1)}ml',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f0825),
                        ),
                      ),
                    ),
                    const Text(
                      'Daily Goal: 2500ml',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 20), // Add space between the texts and the rectangle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding to the left and right of the rectangle
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                        minHeight: 20,
                      ),
                    ),
                    const SizedBox(height: 20), // Add space between the progress bar and the rectangle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding to the left and right of the rectangle
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey), // Add border to the container
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Drink 180ml of water',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1f0825),
                                  ),
                                ),
                                Text(
                                  'Upcoming',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              '4:00 PM', // Time example, replace it with the actual time
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Add space between the rectangle and the bottom of the container
                    ElevatedButton(
                      onPressed: _currentIntake < _dailyGoal ? () => _logWaterIntake(180.0) : null,
                      child: const Text('Log 180ml Water Intake'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}