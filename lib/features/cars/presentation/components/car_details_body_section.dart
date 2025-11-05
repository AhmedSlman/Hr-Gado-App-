import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/empty_state_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../logic/cars_cubit.dart';
import '../../logic/cars_states.dart';
import '../../router/cars_names.dart';

class CarDetailsBodySection extends StatelessWidget {
  const CarDetailsBodySection({super.key});

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (e) {
      // ignore
    }
    return dateStr;
  }

  String _getCarBrandIcon(String model) {
    final lowerModel = model.toLowerCase();
    if (lowerModel.contains('nissan')) {
      return '🚗';
    } else if (lowerModel.contains('toyota')) {
      return '🚙';
    } else if (lowerModel.contains('chevrolet')) {
      return '🚗';
    }
    return '🚗';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsStates>(
      builder: (context, state) {
        if (state is CarDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CarDetailsError) {
          return EmptyStateWidget.withIcon(
            message: 'حدث خطأ في تحميل بيانات السيارة',
            subtitle: state.message,
            icon: Icons.error_outline,
            iconColor: Colors.red,
            actionLabel: 'إعادة المحاولة',
            onAction: () {
              final currentPath = GoRouterState.of(context).uri.path;
              final carId = CarsRoutes.extractCarId(currentPath);
              if (currentPath == CarsRoutes.myCar) {
                CarsCubit.get(context).getMyCar();
              } else if (carId != null) {
                CarsCubit.get(context).getCarDetails(carId);
              }
            },
          );
        }

        if (state is CarDetailsSuccess) {
          final car = state.carDetailsResponse.data;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Car Details Cards
                _buildDetailRow(
                  label: 'نوع السيارة:',
                  value: car.model,
                  icon: _getCarBrandIcon(car.model),
                ),
                SizedBox(height: 16.h),
                _buildDetailRow(label: 'رقم السيارة:', value: car.licensePlate),
                SizedBox(height: 16.h),
                _buildDetailRow(
                  label: 'تاريخ اصدار الرخصة:',
                  value: _formatDate(car.licenseIssue),
                ),
                SizedBox(height: 16.h),
                _buildDetailRow(
                  label: 'تاريخ تجديد الرخصة:',
                  value: _formatDate(car.licenseRenewal),
                ),
                SizedBox(height: 16.h),
                _buildDetailRow(
                  label: 'تاريخ آخر تغيير زيت:',
                  value: _formatDate(car.lastOilChange),
                ),
                SizedBox(height: 16.h),
                _buildDetailRow(
                  label: 'تاريخ تجديد الزيت:',
                  value: _formatDate(car.nextOilChange),
                ),
                SizedBox(height: 16.h),
                _buildDetailRow(label: 'اسم السائق:', value: car.employeeName),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    String? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Right side - Arabic label
        Expanded(
          child: Text(
            label,
            style: AppStyles.s14Medium.copyWith(color: AppColors.grayText),
            textAlign: TextAlign.right,
          ),
        ),
        SizedBox(width: 16.w),
        // Left side - Value
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (icon != null) ...[
                Text(icon, style: TextStyle(fontSize: 18.sp)),
                SizedBox(width: 6.w),
              ],
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s14Medium.copyWith(color: AppColors.black),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
