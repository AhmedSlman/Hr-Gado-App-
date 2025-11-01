import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/widgets/personal_data_field_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/profile_picture_widget.dart';

class PersonalDataSection extends StatelessWidget {
  const PersonalDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is PersonalDataLoading ||
          current is PersonalDataLoadSuccess ||
          current is PersonalDataLoadError,
      listener: (context, state) {
        if (state is PersonalDataLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is PersonalDataLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PersonalDataLoadSuccess) {
          final data = state.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 32.h),
                ProfilePictureWidget(
                  onTap: () {
                    // Handle photo change
                  },
                  imageUrl: data.image,
                ),
                SizedBox(height: 32.h),
                // Personal data fields
                Column(
                  children: [
                    PersonalDataFieldWidget(label: 'الاسم', value: data.name),
                    PersonalDataFieldWidget(label: 'الوظيفة', value: data.job),
                    PersonalDataFieldWidget(
                      label: 'رقم الهاتف',
                      value: data.phone,
                    ),
                    PersonalDataFieldWidget(label: 'المدينة', value: data.city),
                    PersonalDataFieldWidget(
                      label: 'السن',
                      value: data.age.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('لا توجد بيانات'));
      },
    );
  }
}
