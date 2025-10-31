import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/features/salary/data/models/response/report_model.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../logic/report_cubit.dart';
import '../../logic/report_states.dart';
import '../widgets/report_details_body.dart';

class ReportDetailsView extends StatelessWidget {
  final int reportId;
  final Map<String, String> metricsData;
  final String date;
  const ReportDetailsView({
    super.key,
    required this.reportId,
    required this.metricsData,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "تفاصيل التقرير",
              // showBackButton: true,
            ),
            Expanded(
              child: BlocBuilder<ReportCubit, ReportState>(
                builder: (context, state) {
                  if (state is ReportLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (state is ReportError) {
                    return ReportDetailsBody(
                      date: date,
                      reportData: ReportData(
                        id: 0,
                        date: '',
                        content: '',
                        addition: '',
                        additionTarget: '',
                      ),
                      metricsData: metricsData,
                    );
                    // }
                    // return Center(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Icon(
                    //         Icons.error_outline,
                    //         size: 64,
                    //         color: AppColors.grayText,
                    //       ),
                    //       SizedBox(height: 16.h),
                    //       Text(
                    //         state.message,
                    //         style: AppStyles.s16Medium.copyWith(
                    //           color: AppColors.grayText,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       SizedBox(height: 16.h),
                    //       ElevatedButton(
                    //         onPressed: () {
                    //           context.read<ReportCubit>().getReportDetails(
                    //             reportId,
                    //           );
                    //         },
                    //         style: ElevatedButton.styleFrom(
                    //           backgroundColor: AppColors.primary,
                    //           foregroundColor: AppColors.white,
                    //         ),
                    //         child: const Text('إعادة المحاولة'),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  } else if (state is ReportLoaded) {
                    return ReportDetailsBody(
                      reportData: state.reportData,
                      metricsData: metricsData,
                      date: date,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
