// lib/widget/homescreen_workout_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../properties/app_colors.dart';

class WorkoutList extends StatefulWidget {
  final int workoutDay;
  final Map<String, dynamic> workouts;
  const WorkoutList({
    super.key,
    required this.workouts,
    required this.workoutDay,
  });

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  late Map<String, dynamic> exercise;
  late SharedPreferences pref;
  List<bool> tickerCheck = List.filled(12, false);
  @override
  void initState() {
    super.initState();
    exercise = widget.workouts['day-${widget.workoutDay}'];
    _tickerCheck();
  }

  Future<void> _tickerCheck() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      tickerCheck = List.generate(exercise['exercises'].length,
          (index) => pref.getBool('ex${index + 1}') ?? false);
    });
  }

  Future<void> toggleTicker(int index) async {
    setState(() {
      tickerCheck[index] = !tickerCheck[index];
    });
    pref.setBool('ex${index + 1}', tickerCheck[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exercise['exercises'].length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onDoubleTap: () {
            toggleTicker(index);
          },
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.done,
                    color: (tickerCheck[index])
                        ? AppColor.pear.withRed(10).withBlue(30)
                        : AppColor.silver.withOpacity(0.3),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    exercise['exercises']['ex${index + 1}'],
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColor.smokyBlack,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        );
      },
    );
  }
}
