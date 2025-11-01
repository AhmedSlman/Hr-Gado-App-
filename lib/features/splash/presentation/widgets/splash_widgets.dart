import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class SplashHeaderWidget extends StatelessWidget {
  final String title;
  const SplashHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class SplashBodyWidget extends StatelessWidget {
  final bool isLoading;
  const SplashBodyWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAssets.image(
            ImagesAssets.gado,
            height: 150.h,
            width: 150.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 30.h),
          if (isLoading) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
