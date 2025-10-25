import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/features/categories/models/category_model.dart';

/// قائمة الفئات الرئيسية
List<CategoryModel> categories = [
  CategoryModel(
    name: 'الحضور والانصراف',
    icon: AppAssets.cat1,
    route: '/attendance',
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
  ),
  CategoryModel(name: 'الاجتماعات', icon: AppAssets.cat4, route: '/meetings'),
  CategoryModel(name: 'السلف والأجازات', icon: AppAssets.cat5, route: '/news'),
  CategoryModel(name: 'الأخبار', icon: AppAssets.cat6, route: '/'),
  CategoryModel(name: 'السيارات', icon: AppAssets.cat7, route: '/roles'),
  CategoryModel(name: 'العهد', icon: AppAssets.cat9, route: '/sanctions'),
  CategoryModel(name: 'الجزاءات', icon: AppAssets.cat8, route: '/salary'),
];
