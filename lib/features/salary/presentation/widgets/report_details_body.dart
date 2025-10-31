import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/response/report_model.dart';

class ReportDetailsBody extends StatelessWidget {
  final ReportData reportData;
  final Map<String, String> metricsData;
  final String date;
  const ReportDetailsBody({
    super.key,
    required this.reportData,
    required this.metricsData,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Metrics Cards Section
          _buildMetricsSection(),

          SizedBox(height: 24.h),

          // Report Content Section
          _buildReportContentSection(),
        ],
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "تقرير عمل $date",
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
          // textAlign: TextAlign.right,
        ),
        SizedBox(height: 12.h),
        _buildMetricCard(
          label: "عدد الاجهزة",
          value: metricsData['devices'] ?? '0',
        ),

        SizedBox(height: 12.h),

        _buildMetricCard(
          label: "عدد الامتار",
          value: metricsData['meters'] ?? '0',
        ),
      ],
    );
  }

  Widget _buildMetricCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.s16Medium.copyWith(color: AppColors.black),
          ),
          Text(
            value,
            style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "التقرير",
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
          // textAlign: TextAlign.right,
        ),

        SizedBox(height: 12.h),

        // Report Content Box
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Report Content
              Text(
                reportData.content,
                style: AppStyles.s14Medium.copyWith(
                  color: AppColors.black,
                  height: 1.6,
                ),
                textAlign: TextAlign.right,
              ),

              // Addition and Target if available
              if (reportData.addition.isNotEmpty ||
                  reportData.additionTarget.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (reportData.addition.isNotEmpty) ...[
                        Text(
                          "الإضافة:",
                          style: AppStyles.s12Medium.copyWith(
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          reportData.addition,
                          style: AppStyles.s14Regular.copyWith(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                      if (reportData.additionTarget.isNotEmpty) ...[
                        if (reportData.addition.isNotEmpty)
                          SizedBox(height: 8.h),
                        Text(
                          "الهدف:",
                          style: AppStyles.s12Medium.copyWith(
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          reportData.additionTarget,
                          style: AppStyles.s14Regular.copyWith(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
