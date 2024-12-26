import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../properties/app_colors.dart';

class ExerciseList extends StatelessWidget {
  final Map<String, dynamic> workout;
  const ExerciseList({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: workout.length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bolt,
                    color: AppColor.smokyBlack,
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    workout.values.elementAt(index),
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColor.smokyBlack,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          );
        },
      ),
    );
  }
}
