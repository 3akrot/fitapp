// lib/calories.dart
import 'package:healthapp/day-view.dart';
// import 'package:calorie_tracker_app/src/page/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/history_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/theme_notifier.dart';
import 'package:healthapp/shared_preference_service.dart';
import 'package:healthapp/theme.dart';
import 'package:healthapp/router.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesService().init();
  runApp(const CalorieTrackerApp());
}class CalorieTrackerApp extends StatefulWidget {
  const CalorieTrackerApp({super.key});

  @override
  _CalorieTrackerAppState createState() => _CalorieTrackerAppState();
}class _CalorieTrackerAppState extends State<CalorieTrackerApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  late Widget homeWidget;
  late bool signedIn;@override
  void initState() {
    super.initState();
    checkFirstSeen();
  }void checkFirstSeen() {
    const bool firstLaunch = true;if (firstLaunch) {
      homeWidget = const Homepage();
    }
    setState(() {});
  }@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DarkThemeProvider>(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder:
            (BuildContext context, DarkThemeProvider value, Widget? child) {
          return GestureDetector(
              onTap: () => hideKeyboard(context),
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  builder: (_, Widget? child) => ScrollConfiguration(
                      behavior: MyBehavior(), child: child!),
                  theme: themeChangeProvider.darkTheme ? darkTheme : lightTheme,
                  home: homeWidget,
                  onGenerateRoute: RoutePage.generateRoute));
        },
      ),
    );
  }void hideKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
class Homepage extends StatefulWidget {
  const Homepage({super.key});@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: TextButton(
    onPressed: () {
      // Navigate back to homepage
    },
    child: const Text('Go Back!'),
  ),
),
    );
  }@override
  State<StatefulWidget> createState() {
    return _Homepage();
  }
}class _Homepage extends State<Homepage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }void onClickHistoryScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HistoryScreen()));
  }void onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) =>  const DayViewScreen()));
  }@override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));return Scaffold(

        body: Column(
          children: <Widget>[
            
            ElevatedButton(
                onPressed: () {
                  onClickDayViewScreenButton(context);
                },
                child: const Text("Day View")),
            ElevatedButton(
                onPressed: () {
                  onClickHistoryScreenButton(context);
                },
                child: const Text("History Screen")),

          ],
        ));
  }
}class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}