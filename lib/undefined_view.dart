// lib/undefined_view.dart
import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  const UndefinedView({
    required this.routeName,
    super.key,
  });

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route for $routeName is not defined'),
      ),
    );
  }
}