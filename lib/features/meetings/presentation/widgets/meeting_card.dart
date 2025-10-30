import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/core/utils/luncher_helper.dart';
import 'package:hr_app/features/meetings/data/models/response/meeting_model.dart';
import 'package:hr_app/features/meetings/presentation/widgets/participants_avatars.dart';

class MeetingCard extends StatelessWidget {
  final MeetingData meeting;

  const MeetingCard({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          //open meeting
          Utility.launchURL(meeting.link);
        },
        child: Row(
          children: [
            Expanded(child: _buildRightSide()),
            SizedBox(width: 16.w),
            _buildLeftSide(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSide(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            //open options menu as dialog
          },
          child: Icon(Icons.more_vert, color: AppColors.primary, size: 20.sp),
        ),
        SizedBox(height: 12.h),

        ParticipantsAvatars(participants: meeting.participants),
      ],
    );
  }

  Widget _buildRightSide() {
    return Row(
      children: [
        Container(width: 4.w, height: 40.h, color: const Color(0xFF5ECD8E)),

        SizedBox(width: 12.w),

        // Meeting Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Meeting Title
              Row(
                children: [
                  AppAssets.svg(AppAssets.googleMeet),
                  SizedBox(width: 8.w),
                  Text(
                    meeting.title,
                    style: AppStyles.s16Medium.copyWith(color: AppColors.black),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              Text(
                meeting.formattedTime,
                style: AppStyles.s14Medium.copyWith(color: AppColors.grayText),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
