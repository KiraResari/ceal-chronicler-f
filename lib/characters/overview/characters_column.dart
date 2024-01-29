import 'package:flutter/material.dart';

class CharactersColumn extends StatelessWidget {
  final String title;

  const CharactersColumn({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.headlineSmall!;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(title, style: style),
    );
  }
}
