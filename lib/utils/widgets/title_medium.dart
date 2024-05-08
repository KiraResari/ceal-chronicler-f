import 'package:flutter/material.dart';

class TitleMedium extends StatelessWidget {
  final String title;

  const TitleMedium({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.headlineMedium!;
    return  Text(title, style: style);
  }
}
