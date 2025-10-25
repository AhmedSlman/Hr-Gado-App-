import 'package:flutter/material.dart';
import '../components/news_components.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: const [NewsHeaderSection()])),
    );
  }
}
