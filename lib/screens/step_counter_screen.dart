// lib/screens/step_counter_screen.dart
import 'package:flutter/material.dart';
import 'package:healthapp/models/health_data.dart';
import 'package:healthapp/providers/step_counter_provider.dart';
import 'dart:async';
import 'package:healthapp/services/pedometer.dart';
import 'package:healthapp/utils/utils.dart';
import 'package:healthapp/widgets/calories_card.dart';
import 'package:healthapp/widgets/graph_card.dart';
import 'package:healthapp/widgets/steps_card.dart';
import 'package:provider/provider.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'stopped';

  @override
  void initState() {
    super.initState();
    debugPrint('StepCounterScreenState: initState');
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    debugPrint('"Event" : $event');
    Provider.of<StepCounterProvider>(context, listen: false).addSteps(
      formatDateForProvider(DateTime.now()),
      int.parse(event.steps.toString()),
    );
    setState(() {
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint(event.toString());
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    debugPrint(error.toString());
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    setState(() {
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Counter'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: cardWidth + 50,
                            width: cardWidth,
                            child: StepsCard(
                              status: _status,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: cardWidth + 50,
                            width: cardWidth,
                            child: const CaloriesCard(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HealthChart(stepCounts: [
                      StepCountData(0, 100),
                      StepCountData(1, 20),
                      StepCountData(2, 600),
                      StepCountData(3, 250),
                      StepCountData(4, 439),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}