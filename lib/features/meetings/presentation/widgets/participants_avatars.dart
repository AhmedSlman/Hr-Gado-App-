import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/meetings/data/models/response/meeting_model.dart';

class ParticipantsAvatars extends StatelessWidget {
  final List<Participant> participants;

  const ParticipantsAvatars({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    // Take only the first 3 participants
    final validParticipants = participants.take(3).toList();
    final remainingCount = participants.length - validParticipants.length;

    // Calculate total width needed for the stack
    final avatarWidth = 32.w;
    final overlapOffset = 8.w;
    final totalWidth =
        validParticipants.length * (avatarWidth - overlapOffset) +
        (remainingCount > 0 ? avatarWidth - overlapOffset : 0);

    return SizedBox(
      width: totalWidth,
      height: avatarWidth,
      child: Stack(
        children: [
          // Show up to 3 participant avatars
          ...validParticipants.asMap().entries.map((entry) {
            final index = entry.key;
            final participant = entry.value;

            return Positioned(
              left: index * (avatarWidth - overlapOffset),
              child: _buildAvatar(participant.image),
            );
          }),

          // Show remaining count if there are more than 3 participants
          if (remainingCount > 0)
            Positioned(
              left: validParticipants.length * (avatarWidth - overlapOffset),
              child: _buildRemainingCount(remainingCount),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String imageUrl) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.lightBlue,
            child: Icon(Icons.person, color: AppColors.white, size: 16.sp),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.lightBlue,
            child: Icon(Icons.person, color: AppColors.white, size: 16.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildRemainingCount(int count) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightBlue,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
