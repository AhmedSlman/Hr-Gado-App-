import 'package:flutter/material.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAssets.svg(IconsAssets.profile),
            SizedBox(height: 20),
            Text('Welcome to the App!'),
          ],
        ),
      ),
    );
  }
}
