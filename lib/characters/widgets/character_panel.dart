import 'package:flutter/material.dart';

import '../model/character.dart';

class CharacterPanel extends StatelessWidget {
  final Character character;

  const CharacterPanel(this.character, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color cardColor = theme.colorScheme.inversePrimary;
    return Card(
      color: cardColor,
      child: _buildTextAndButtons(),
    );
  }

  Row _buildTextAndButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(character.name),
        ),
      ],
    );
  }
}
