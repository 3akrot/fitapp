// lib/main.dart
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthapp/sleep.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/screens/sleep_monitor_screen.dart';
import 'package:healthapp/screens/step_counter_screen.dart';
import 'package:healthapp/providers/sleep_monitor_provider.dart';
import 'package:healthapp/providers/step_counter_provider.dart';

import 'dart:async';
import 'firebase_options.dart';
import 'chatbot.dart';
import 'login.dart'; // Import the login page
import 'signup.dart'; // Import the signup page
import 'HomePage.dart';
import 'medication.dart';
import 'appointments.dart';
import 'Fitness_Page.dart';
import 'nurtition_screen.dart';
import 'fitness.dart';
import 'notification_service.dart'; // Import the NotificationService class
import 'water_remainder.dart';
import 'firebaseAUTH/auth.dart';
import 'calories.dart' as cals;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsernameProvider extends ChangeNotifier {
  String _username = '';

  String get username => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners(); // Notify listeners that the username has changed
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final AuthService _authService = AuthService();
  List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final NotificationService notificationService = NotificationService();
  await notificationService
      .initializeNotifications(); // Initialize notifications
// Initialize the plugin
  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message received: ${message.notification?.title}");
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Message'),
          content: Text(message.notification?.title ?? ''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog first
                notificationService.handleMessage(message);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ChangeNotifierProvider(
      create: (context) => UsernameProvider(),
      child: const MyApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received213332: ${message.notification?.title}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Define the design size you are targeting
      minTextAdapt: true, // This will make sure the text scaling happens
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => StepCounterProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => SleepMonitorProvider(),
            ),
            
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Health App',
            initialRoute: '/', // Set the initial route
            routes: {
              '/': (context) => const HomePage(), // Use HomePage as the root route
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
              '/AndriodPrototype': (context) => const AndriodPrototype(),
              '/medication': (context) => const MedicationAlarmScreen(),
              '/FitnessPage': (context) => const FitnessPage(),
              '/sleep': (context) => SleepPage(
                    authService: _authService,
                  ),
              '/fitness': (context) => const FitnessScreen(),
              '/water': (context) => const WaterReminder(),
              '/nutrition': (context) => const RecipeScreen(),
              '/appointment': (context) => const AppointmentsPage(),
              '/chatbot': (context) => const ChatScreen(),
              '/cals':(context) => const cals.Homepage(),
              '/step_counter': (context) => const StepCounterScreen(),
              '/sleep_monitor': (context) => const SleepMonitorScreen(),
            },
          ),
        );
      },
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FitApp'),
          backgroundColor: const Color(0xFF1E88E5), // Changed to a blue color
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 280,
              child: Image.asset(
                'assets/workout_at_home.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E88E5), // Changed to a blue color
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Welcome to FitApp',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Your fitness journey starts here.",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E88E5), // Changed to a blue color
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(color: Color(0xFF1E88E5)), // Changed to a blue color
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF1E88E5), // Changed to a blue color
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}