// lib/screens/workouts.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/daywiseWorkouts/workouts_arms.dart';
import '../widget/daywiseWorkouts/workouts_back.dart';
import '../widget/daywiseWorkouts/workouts_cardio.dart';
import '../widget/daywiseWorkouts/workouts_chest.dart';
import '../widget/daywiseWorkouts/workouts_legs.dart';
import '../widget/daywiseWorkouts/wourkouts_shoulder.dart';
import '../widget/workouts_bottomappbar.dart';

class WorkoutsPage extends StatelessWidget {
  final Map<String, dynamic> workouts;
  final PageController slider = PageController();
  WorkoutsPage({
    super.key,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60.h, left: 20.w, right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 40.h,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: PageView(
                controller: slider,
                children: [
                  Shoulders(
                    workout: workouts['day-1'],
                  ),
                  Chest(
                    workout: workouts['day-2'],
                  ),
                  Back(
                    workout: workouts['day-3'],
                  ),
                  Arms(
                    workout: workouts['day-4'],
                  ),
                  Legs(
                    workout: workouts['day-5'],
                  ),
                  Cardio(
                    workout: workouts['day-6'],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: WorkoutsBottomAppBar(
        workoutImgNames: workouts,
        slideTo: slider,
      ),
    );
  }
}
