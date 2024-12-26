// lib/theme_notifier.dart
import 'package:flutter/cupertino.dart';
import 'package:healthapp/shared_preference_service.dart';
class DarkThemeProvider with ChangeNotifier {
  // The 'with' keyword is similar to mixins in JavaScript, in that it is a way of reusing a class's fields/methods in a different class that is not a super class of the initial class.bool
   get darkTheme {
    return SharedPreferencesService.getDarkTheme();
  }set dartTheme(bool value) {
    SharedPreferencesService.setDarkTheme(to: value);
    notifyListeners();
  }
}