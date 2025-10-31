import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_app/core/theme/app_colors.dart';

class NavApp extends StatefulWidget {
  const NavApp({super.key, required this.index, this.onSelect});
  final int index;
  final Function(int)? onSelect;

  @override
  State<NavApp> createState() => _NavAppState();
}

class _NavAppState extends State<NavApp> {
  int index = 0;
  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  Color _selectedColor(int index) =>
      widget.index == index ? AppColors.primary : AppColors.lightBlue;
  NavItem items(index) => [
    NavItem(
      index: 0,
      title: "الرئيسية",
      image: "assets/svgs/home.svg",
      activeImage: "assets/svgs/active_home.svg",
    ),
    NavItem(
      index: 1,
      title: "الخصائص",
      image: "assets/svgs/category.svg",
      activeImage: "assets/svgs/active_category.svg",
    ),
   
    NavItem(
      index: 2,
      title: "الحساب",
      image: "assets/svgs/profile-circle.svg",
      activeImage: "assets/svgs/active-profile-circle.svg",
    ),
  ][index];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                widget.onSelect?.call(index);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 8.h),
                    SvgPicture.asset(
                      widget.index == index
                          ? items(index).activeImage
                          : items(index).image,
                      colorFilter: ColorFilter.mode(
                        _selectedColor(index),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      items(index).title,
                      style: TextStyle(
                        color: _selectedColor(index),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}

class NavItem {
  final String title;
  final String image;
  final String activeImage;
  final int index;
  NavItem({
    required this.title,
    required this.image,
    required this.activeImage,
    required this.index,
  });
}
