import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../properties/app_colors.dart';
import '../properties/loader.dart';

class WorkoutLoader extends StatelessWidget {
  final LoaderStatus workoutLoading;
  final VoidCallback tryAgain;
  const WorkoutLoader({
    super.key,
    required this.workoutLoading,
    required this.tryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/Gym-amico.png',
            height: MediaQuery.of(context).size.height * .35,
          ),
          (workoutLoading == LoaderStatus.isLoading)
              ? Wrap(
                  children: [
                    Text(
                      "Hold on...",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColor.smokyBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.7.w,
                        color: AppColor.smokyBlack,
                      ),
                    ),
                  ],
                )
              : (workoutLoading == LoaderStatus.errorLoading)
                  ? Text(
                      "Couldn't reach the server",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColor.smokyBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "Check your internet connectivity",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColor.smokyBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          if (workoutLoading == LoaderStatus.errorLoading)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                fixedSize: Size(210.w, 20.h),
                backgroundColor: AppColor.pear,
              ),
              onPressed: tryAgain,
              child: Wrap(
                children: [
                  Text(
                    "Retry",
                    style: TextStyle(
                      color: AppColor.smokyBlack,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  const Icon(
                    Icons.refresh,
                    color: AppColor.smokyBlack,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
