import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

import '../../logic/meetings_cubit.dart';
import '../../router/meetings_names.dart';

class AddMeetingButton extends StatelessWidget {
  const AddMeetingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await context.push<bool>(MeetingsRoutes.addMeeting);
            if (result == true) {
              MeetingsCubit.get(context).getMyMeetings();
            }
          },
          borderRadius: BorderRadius.circular(8.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.white,
                  radius: 8.r,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "اضافة اجتماع",
                  style: AppStyles.s14Medium.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
