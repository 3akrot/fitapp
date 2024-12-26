import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../properties/app_colors.dart';

class WorkoutsBottomAppBar extends StatelessWidget {
  final Map<String, dynamic> workoutImgNames;
  final PageController slideTo;
  const WorkoutsBottomAppBar({
    super.key,
    required this.workoutImgNames,
    required this.slideTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: AppColor.pear,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 8.w,
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: workoutImgNames.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.5.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      slideTo.jumpToPage(index);
                    },
                    child: Image.asset(
                      'assets/img/${workoutImgNames['day-${index + 1}']['targetMuscle']}.png',
                      height: 35.h,
                      width: 35.h,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
