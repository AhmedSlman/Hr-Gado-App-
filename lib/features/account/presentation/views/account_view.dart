import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/presentation/widgets/account_menu_item_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/logout_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            CustomAppBar(title: "الحساب"),
            Expanded(
              child: ListView(
                children: [
                  AccountMenuItemWidget(
                    icon: Icons.person,
                    title: 'البيانات الشخصية',
                    onTap: () {
                      context.push(AccountRoutes.personalData);
                    },
                  ),
                  AccountMenuItemWidget(
                    icon: Icons.people,
                    title: 'الموظفين',
                    onTap: () {
                      context.push(AccountRoutes.employees);
                    },
                  ),
                  AccountMenuItemWidget(
                    icon: Icons.description,
                    title: 'تقارير الموظفين',
                    onTap: () {},
                  ),
                  AccountMenuItemWidget(
                    icon: Icons.help_outline,
                    title: 'طلبات الموظفين',
                    onTap: () {
                      context.push(AccountRoutes.employeeRequests);
                    },
                  ),
                  AccountMenuItemWidget(
                    icon: Icons.chat_bubble_outline,
                    title: 'تقديم اقتراحات و شکاوی',
                    onTap: () {},
                  ),

                  const LogoutWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
