import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/cars/router/cars_names.dart';
import 'package:hr_app/features/categories/models/category_model.dart';
import 'package:hr_app/features/meetings/router/meetings_names.dart';
import 'package:hr_app/features/news/router/news_names.dart';
import 'package:hr_app/features/salary/router/salary_names.dart';
import 'package:hr_app/features/salary_deduction/router/salary_deduction_names.dart';
import 'package:hr_app/features/time_sheet/router/time_sheet_names.dart';
import 'package:hr_app/features/vacation/router/vacation_names.dart';

/// قائمة الفئات الرئيسية
List<CategoryModel> categories = [
  CategoryModel(
    name: 'الحضور والانصراف',
    icon: AppAssets.cat1,
    route: '/attendance',
    onTap: (context) {
      context.push(TimeSheetRoutes.timeSheet);
    },
  ),
  CategoryModel(
    name: 'قوانين و لوئح',
    icon: AppAssets.cat2,
    route: '/vehicles',
  ),
  CategoryModel(
    name: 'رصيدك من الراتب',
    icon: AppAssets.cat3,
    route: '/leaves',
    onTap: (context) {
      context.push(SalaryRoutes.salary);
    },
  ),
  CategoryModel(
    name: 'الاجتماعات',
    icon: AppAssets.cat4,
    route: '/meetings',
    onTap: (context) {
      context.push(MeetingsRoutes.meetings);
    },
  ),
  CategoryModel(
    name: 'السلف والأجازات',
    icon: AppAssets.cat5,
    route: '/vacation',
    onTap: (context) {
      context.push(VacationRoutes.vacation);
    },
  ),
  CategoryModel(
    name: 'الأخبار',
    icon: AppAssets.cat6,
    route: '/',
    onTap: (context) {
      context.push(NewsRoutes.news);
    },
  ),
  CategoryModel(
    name: 'السيارات',
    icon: AppAssets.cat7,
    route: '//',
    onTap: (context) {
      if (UserHelper.userRole == 'Manager') {
        log('Manager');
        context.push(CarsRoutes.cars);
      } else {
        log('Employee');
        context.push(CarsRoutes.myCar);
      }
    },
  ),
  CategoryModel(name: 'العهد', icon: AppAssets.cat9, route: '/sanctions'),
  CategoryModel(
    name: 'الجزاءات',
    icon: AppAssets.cat8,
    route: '/salary-deduction',
    onTap: (context) {
      context.push(SalaryDeductionRoutes.deductions);
    },
  ),
];
