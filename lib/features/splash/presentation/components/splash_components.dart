import 'package:flutter/material.dart';
import '../widgets/splash_widgets.dart';

class SplashHeaderSection extends StatelessWidget {
  const SplashHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashHeaderWidget(title: 'Splash Screen');
  }
}

class SplashBodySection extends StatelessWidget {
  const SplashBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashBodyWidget(isLoading: false);
  }
}
