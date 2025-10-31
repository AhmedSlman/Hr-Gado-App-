import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/salary/data/models/response/salary_model.dart';
import 'package:hr_app/features/salary/router/salary_names.dart';

class SalaryTransactionCard extends StatelessWidget {
  final String date;
  final Map<String, String> metricsData;
  final String salary;
  final String? badgeText;
  final Color? badgeColor;
  final bool hasReport;
  final EmployeeType employeeType;
  final int? reportId;

  const SalaryTransactionCard({
    super.key,
    required this.date,
    required this.metricsData,
    required this.salary,
    this.badgeText,
    this.badgeColor,
    this.hasReport = false,
    required this.employeeType,
    this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: AppStyles.s14Medium.copyWith(color: AppColors.black),
                    textAlign: TextAlign.right,
                  ),
                  if (hasReport && reportId != null)
                    GestureDetector(
                      onTap: () {
                        context.go(
                          SalaryRoutes.reportDetails,
                          extra: {
                            'reportId': reportId,
                            'metricsData': metricsData,
                            'date': date,
                          },
                        );
                       
                      },
                      child: Row(
                        children: [
                          Text(
                            "عرض تفاصيل التقرير",
                            style: AppStyles.s12.copyWith(
                              color: AppColors.grayText,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: AppColors.grayText,
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Build metrics columns based on employee type
              _buildMetricsColumns(),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsColumns() {
    switch (employeeType) {
      case EmployeeType.driver:
        return _buildDriverColumns();
      case EmployeeType.sales:
        return _buildSalesColumns();
      case EmployeeType.technician:
        return _buildTechnicianColumns();
      case EmployeeType.other:
        return _buildOtherColumns();
    }
  }

  // Driver columns: الراتب | عدد الامتار | عدد الاجهزة
  Widget _buildDriverColumns() {
    return Row(
      children: [
        _buildSalaryColumn(),
        _buildDivider(),
        _buildMetricColumn(
          label: "عدد الامتار",
          value: metricsData['meters'] ?? '0',
        ),
        _buildDivider(),
        _buildMetricColumn(
          label: "عدد الاجهزة",
          value: metricsData['devices'] ?? '0',
        ),
      ],
    );
  }

  // Sales columns: الراتب | الأجهزة المباعة | الأجهزة المشتراة | الأجهزة التجارية
  Widget _buildSalesColumns() {
    return Row(
      children: [
        _buildSalaryColumn(),
        _buildDivider(),
        _buildMetricColumn(
          label: "الأجهزة المباعة",
          value: metricsData['sold_devices'] ?? '0',
        ),
        _buildDivider(),
        _buildMetricColumn(
          label: "الأجهزة المشتراة",
          value: metricsData['bought_devices'] ?? '0',
        ),
        _buildDivider(),
        _buildMetricColumn(
          label: "الأجهزة التجارية",
          value: metricsData['commercial_devices'] ?? '0',
        ),
      ],
    );
  }

  // Technician columns: الراتب | عدد الامتار | عدد الاجهزة
  Widget _buildTechnicianColumns() {
    return Row(
      children: [
        _buildSalaryColumn(),
        _buildDivider(),
        _buildMetricColumn(
          label: "عدد الامتار",
          value: metricsData['meters'] ?? '0',
        ),
        _buildDivider(),
        _buildMetricColumn(
          label: "عدد الاجهزة",
          value: metricsData['devices'] ?? '0',
        ),
      ],
    );
  }

  // Other columns: الراتب | ساعات العمل الإضافية
  Widget _buildOtherColumns() {
    return Row(
      children: [
        _buildSalaryColumn(),
        _buildDivider(),
        _buildMetricColumn(
          label: "ساعات العمل الإضافية",
          value: metricsData['overtime_hours'] ?? '0',
        ),
      ],
    );
  }

  Widget _buildSalaryColumn() {
    return Expanded(
      child: Column(
        children: [
          Text(
            "الراتب",
            style: AppStyles.s14Medium.copyWith(color: AppColors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                salary,
                style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
                textAlign: TextAlign.right,
              ),
              if (badgeText != null && badgeColor != null) ...[
                SizedBox(width: 6.w),
                Text(
                  badgeText!,
                  style: AppStyles.s10Medium.copyWith(color: badgeColor),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn({required String label, required String value}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppStyles.s14Medium.copyWith(color: AppColors.black),
          ),
          Text(
            value,
            style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 3.0.w,
      height: 40.0.h,
      color: AppColors.primary,
      margin: EdgeInsets.symmetric(horizontal: 8.0.w),
    );
  }
}
