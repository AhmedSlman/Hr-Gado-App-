import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/meetings/data/models/response/meeting_model.dart';
import 'package:hr_app/features/meetings/presentation/widgets/meeting_card.dart';

class MeetingsList extends StatelessWidget {
  final List<MeetingData> meetings;

  const MeetingsList({super.key, required this.meetings});

  @override
  Widget build(BuildContext context) {
    // Group meetings by date
    final groupedMeetings = _groupMeetingsByDate(meetings);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedMeetings.length,
      itemBuilder: (context, index) {
        final entry = groupedMeetings.entries.elementAt(index);
        final date = entry.key;
        final meetingsForDate = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Padding(
              padding: EdgeInsets.only(bottom: 12.h, top: index > 0 ? 24.h : 0),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Meetings for this date
            ...meetingsForDate.map(
              (meeting) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: MeetingCard(meeting: meeting),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<MeetingData>> _groupMeetingsByDate(
    List<MeetingData> meetings,
  ) {
    final Map<String, List<MeetingData>> grouped = {};

    for (final meeting in meetings) {
      final date = meeting.formattedDate;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(meeting);
    }

    // Sort meetings within each date by time
    grouped.forEach((date, meetings) {
      meetings.sort((a, b) => a.time.compareTo(b.time));
    });

    return grouped;
  }
}

