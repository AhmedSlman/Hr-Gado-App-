import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

import '../../data/models/response/car_model.dart';
import '../../logic/cars_cubit.dart';
import '../../router/cars_names.dart';

class CarCard extends StatelessWidget {
  final CarListItem car;

  const CarCard({super.key, required this.car});

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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Value on the left
        Text(
          label,
          style: AppStyles.s14Medium.copyWith(color: AppColors.grayText),
          textAlign: TextAlign.right,
        ),
        Text(
          value,
          style: AppStyles.s14Medium.copyWith(color: AppColors.black),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    // Save the original context that has access to CarsCubit
    final cubitContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('حذف السيارة', style: AppStyles.s16Medium),
        content: Text(
          'هل أنت متأكد من حذف هذه السيارة؟',
          style: AppStyles.s14Medium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'إلغاء',
              style: AppStyles.s14Medium.copyWith(color: AppColors.grayText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              CarsCubit.get(cubitContext).deleteCar(car.id);
            },
            child: Text(
              'حذف',
              style: AppStyles.s14Medium.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
              context.push(CarsRoutes.carDetails(car.id));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Three dots menu - horizontal at the top
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_horiz,
                        color: AppColors.lightBlue,
                        size: 20.sp,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          final result = await context.push<bool>(
                            CarsRoutes.addCar,
                            extra: car.id,
                          );
                          if (result == true && context.mounted) {
                            CarsCubit.get(context).getCars();
                          }
                        } else if (value == 'delete') {
                          _showDeleteDialog(context);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'edit',

                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.black,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'تعديل',
                                style: AppStyles.s14Medium.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'حذف',
                                style: AppStyles.s14Medium.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Detail rows - each row has label (right) and value (left)
                _buildDetailRow(
                  'نوع السيارة:',
                  '${_getCarBrandIcon(car.model)} ${car.model}',
                ),
                SizedBox(height: 8.h),
                _buildDetailRow('رقم السيارة:', car.licensePlate),
                SizedBox(height: 8.h),
                _buildDetailRow(
                  'تاريخ تجديد الرخصة:',
                  _formatDate(car.licenseRenewal),
                ),
                SizedBox(height: 8.h),
                _buildDetailRow(
                  'تاريخ تجديد الزيت:',
                  _formatDate(car.nextOilChange),
                ),
              ],
            ),
          ),
        ),

        // Blue line on the right
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
}
