import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_model.dart';

class EmployeeReportCardWidget extends StatelessWidget {
  final EmployeeReportModel report;
  final VoidCallback? onTap;

  const EmployeeReportCardWidget({super.key, required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // View details link - at the top
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.date,
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
                Spacer(),
                Text(
                  'عرض تفاصيل التقرير',
                  style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Employee name
          Text(
            report.name,
            style: AppStyles.s16Medium.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 12.h),
          // Dynamic content based on report type
          _buildReportContent(),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    // Type 3: devices + meters
    if (report.isType3) {
      return Row(
        children: [
          Expanded(
            child: _buildStatColumn(
              label: 'عدد الاجهزة',
              value: report.displayDevices ?? '0',
            ),
          ),
          Container(width: 1.w, height: 40.h, color: AppColors.lightBlue),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatColumn(
              label: 'عدد الامتار',
              value: report.displayMeters ?? '0',
            ),
          ),
        ],
      );
    }

    // Type 1: devices + overtime
    if (report.isType1) {
      return Row(
        children: [
          Expanded(
            child: _buildStatColumn(
              label: 'عدد الاجهزة',
              value: report.displayDevices ?? '0',
            ),
          ),
          Container(width: 1.w, height: 40.h, color: AppColors.lightBlue),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatColumn(
              label: 'ساعات اضافية',
              value: report.overtimeHours?.toString() ?? '0',
            ),
          ),
        ],
      );
    }

    // Type 2: sold + bought + commercial devices
    if (report.isType2) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  label: 'مباع',
                  value: report.soldDevices?.toString() ?? '0',
                ),
              ),
              Container(width: 1.w, height: 40.h, color: AppColors.lightBlue),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStatColumn(
                  label: 'مشترى',
                  value: report.boughtDevices?.toString() ?? '0',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  label: 'تجاري',
                  value: report.commercialDevices?.toString() ?? '0',
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Fallback: show basic info
    return Text(
      'تقرير عمل',
      style: AppStyles.s14.copyWith(color: AppColors.grayText),
    );
  }

  Widget _buildStatColumn({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppStyles.s14.copyWith(color: AppColors.grayText)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppStyles.s16Medium.copyWith(color: AppColors.black),
        ),
      ],
    );
  }
}
