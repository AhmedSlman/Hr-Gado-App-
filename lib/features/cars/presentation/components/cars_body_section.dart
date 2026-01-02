import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/empty_state_widget.dart';
import 'package:hr_app/core/utils/user_helper.dart';

import '../../../meetings/presentation/widgets/add_meeting_button.dart';
import '../../logic/cars_cubit.dart';
import '../../logic/cars_states.dart';
import '../../router/cars_names.dart';
import 'cars_list.dart';

class CarsBodySection extends StatelessWidget {
  const CarsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarsCubit, CarsStates>(
      listener: (context, state) {
        if (state is DeleteCarSuccess) {
          CustomSnackBar.showSuccess(context, message: state.message);
        }
        if (state is DeleteCarError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is CarsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CarsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'حدث خطأ: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    CarsCubit.get(context).getCars();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is CarsSuccess) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  // Add Car Button - only for Manager
                  UserHelper.userRole == 'Manager'
                      ? AddButton(
                          title: 'اضافة سيارة',
                          onTap: () async {
                            final result = await context.push<bool>(
                              CarsRoutes.addCar,
                            );
                            if (result == true) {
                              CarsCubit.get(context).getCars();
                            }
                          },
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: 24.h),
                  // Cars List
                  if (state.carsResponse.data.isEmpty)
                    EmptyStateWidget.simple(
                      message: 'لا توجد سيارات',
                      icon: Icons.directions_car_outlined,
                    )
                  else
                    CarsList(cars: state.carsResponse.data),
                  SizedBox(height: 24.h),
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
