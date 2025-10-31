import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/features/account/presentation/widgets/employee_card_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';

class EmployeesGridViewSection extends StatelessWidget {
  EmployeesGridViewSection({super.key});

  final employees = List.generate(
    16,
    (index) => {
      'name': index % 2 == 0 ? 'هبه محمد' : 'طارق على',
      'role': 'خدمة عملاء',
      'imageUrl': null,
    },
  );
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return EmployeeCardWidget(
              name: employee['name']!,
              role: employee['role']!,
              imageUrl: employee['imageUrl'],
              onTap: () {
                // Navigate to employee personal data
                context.push(AccountRoutes.personalData);
              },
            );
          },
        ),
      ),
    );
  }
}
