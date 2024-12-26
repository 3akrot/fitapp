// lib/widget/homescreen_appbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../properties/app_colors.dart';

class WorkoutHeading extends StatelessWidget {
  final MaterialPageRoute Function() workoutsPage;
  final String workoutType;
  const WorkoutHeading({
    super.key,
    required this.workoutType,
    required this.workoutsPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's workout routine",
              style: TextStyle(
                color: AppColor.silver,
                fontSize: 20.sp,
              ),
            ),
            Text(
              workoutType,
              style: TextStyle(
                color: AppColor.smokyBlack,
                fontSize: 45.sp,
                height: .8.h,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, workoutsPage());
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.r),
                  ),
                  color: AppColor.pear,
                ),
                height: 65.h,
                width: 65.h,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/img/$workoutType.png',
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8.r),
                  ),
                  color: AppColor.pear,
                ),
                padding: EdgeInsets.only(
                  bottom: 5.h,
                ),
                width: 65.h,
                child: Text(
                  "Workouts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 0.7.h,
                    color: AppColor.smokyBlack,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
