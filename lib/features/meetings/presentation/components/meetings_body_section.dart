import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/empty_state_widget.dart';
import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/meetings/logic/meetings_cubit.dart';
import 'package:hr_app/features/meetings/logic/meetings_states.dart';
import 'package:hr_app/features/meetings/presentation/components/meetings_list.dart';
import 'package:hr_app/features/meetings/presentation/widgets/add_meeting_button.dart';
import 'package:hr_app/features/meetings/router/meetings_names.dart';

class MeetingsBodySection extends StatelessWidget {
  const MeetingsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingsCubit, MeetingsStates>(
      builder: (context, state) {
        if (state is MeetingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MeetingsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'حدث خطأ: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    MeetingsCubit.get(context).getMyMeetings();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is MeetingsSuccess) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Add Meeting Button (Manager only)
                  UserHelper.isManager
                      ? AddButton(
                          title: 'اضافة اجتماع',
                          onTap: () async {
                            final result = await context.push<bool>(
                              MeetingsRoutes.addMeeting,
                            );
                            if (result == true) {
                              MeetingsCubit.get(context).getMyMeetings();
                            }
                          },
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 24),

                  // Meetings List or Empty State
                  if (state.meetingsResponse.data.isEmpty)
                    EmptyStateWidget.withImage(
                      message: 'لم يتم تحديد أي اجتماعات حتى الآن.سيتم إشعارك عند إضافة أي اجتماعات جديدة!',
                      imagePath: AppAssets.emptyMeeting,
                      imageWidth: 100,
                      imageHeight: 100,
                      topPadding: 0,
                      bottomPadding: 0,
                    )
                  else
                    MeetingsList(meetings: state.meetingsResponse.data),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
