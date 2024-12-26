// lib/notpage.dart
import 'package:flutter/material.dart';
import 'package:healthapp/local_notification.dart';

class NotPage extends StatefulWidget {
  const NotPage({super.key});

  @override
  State<NotPage> createState() => _NotpageState();
}

class _NotpageState extends State<NotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NOTIFICATIONAA"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            LocalNotification.showNotification(
                title: "noti", body: "this is TEST", payload: "this is simple");
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}
