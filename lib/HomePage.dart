// lib/HomePage.dart
import 'package:flutter/material.dart';
import 'package:healthapp/chatbot.dart';
import 'package:healthapp/day-view.dart';
import 'package:healthapp/firebaseAUTH/auth.dart';
import 'package:healthapp/main.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/providers/sleep_monitor_provider.dart';
import 'package:healthapp/providers/step_counter_provider.dart';
import 'package:healthapp/profile.dart';
import 'package:camera/camera.dart';
import 'package:healthapp/screens/homepage.dart' as HW;
import 'package:healthapp/futures.dart';

class AndriodPrototype extends StatefulWidget {
  const AndriodPrototype({super.key});

  @override
  _AndriodPrototypeState createState() => _AndriodPrototypeState();
}

class _AndriodPrototypeState extends State<AndriodPrototype> {
  int _currentIndex = 0;
  late Future<List<CameraDescription>> cameras; // Declare the camera list as a Future
  final PageStorageBucket bucket = PageStorageBucket(); // Create a PageStorageBucket

  @override
  void initState() {
    super.initState();
    // Initialize the cameras by calling availableCameras asynchronously
    cameras = availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    String userName = Provider.of<UsernameProvider>(context).username;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness app'),
      ),
      body: FutureBuilder<List<CameraDescription>>(
        future: cameras, // Wait for cameras to be available
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting for cameras
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading cameras")); // Handle error if cameras fail to load
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No cameras found")); // Handle no cameras found
          }

          final List<CameraDescription> camerasList = snapshot.data!;

          final List<Widget> screens = [
            const HomePageContent(), // Use a widget for HomePage content
            PageStorage(
              bucket: bucket,
              child: const ChatScreen(key: PageStorageKey('ChatScreen')),
            ),
            const DayViewScreen(),
            FuturesScreen(),
            ProfilePage(user: AuthService().getCurrentUser()), // Pass the User object to the ProfilePage
          ];

          return screens[_currentIndex]; // Dynamically load the screen based on the index
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change the index to load the corresponding screen
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'AI Coach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Calories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Features',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    String userName = Provider.of<UsernameProvider>(context).username;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/homepage1.jpeg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello $userName',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome Your Fitness Manger',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildAdviceContainer(
                  context,
                  'Sleep Early',
                  'Get at least 7-9 hours of sleep for better health.',
                  Icons.nights_stay,
                ),
                const SizedBox(width: 20),
                buildAdviceContainer(
                  context,
                  'Walk Daily',
                  'Take a walk for at least 30 minutes every day.',
                  Icons.directions_walk,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              surfaceTintColor: Colors.blue,
              elevation: 5,
              child: SizedBox(
                height: 100,
                child: Center(
                  child: ListTile(
                    title: const Text('Step Counter'),
                    subtitle: Text(
                      "Today's total Steps: ${Provider.of<StepCounterProvider>(context, listen: true).todaySteps}",
                    ),
                    trailing: const Icon(
                      Icons.directions_walk,
                      color: Colors.blue,
                      size: 40,
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, '/step_counter'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              surfaceTintColor: Colors.blue,
              elevation: 5,
              child: SizedBox(
                height: 100,
                child: Center(
                  child: ListTile(
                    title: const Text('Sleep Monitor'),
                    subtitle: const Text(
                      "click to see your sleep info",
                    ),
                    trailing: const Icon(
                      Icons.local_hotel,
                      color: Color.fromARGB(255, 2, 119, 236),
                      size: 40,
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, '/sleep_monitor'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdviceContainer(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
