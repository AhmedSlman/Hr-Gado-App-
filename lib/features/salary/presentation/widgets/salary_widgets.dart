import 'package:flutter/material.dart';

class SalaryHeaderWidget extends StatelessWidget {
  final String title;
  const SalaryHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title),
    );
  }
}

class SalaryBodyWidget extends StatelessWidget {
  final List items;
  const SalaryBodyWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item #$index'),
        );
      },
    );
  }
}


