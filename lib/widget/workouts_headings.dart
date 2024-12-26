import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../properties/app_colors.dart';

class WorkoutListHeading extends StatelessWidget {
  final String workoutType;
  const WorkoutListHeading({
    super.key,
    required this.workoutType,
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
              "Workout routine for",
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
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
        )
      ],
    );
  }
}
