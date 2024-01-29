import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'character_overview_controller.dart';
import 'characters_column.dart';

class CharacterOverview extends StatelessWidget {
  static const String unintroducedCharactersTitle = "Unintroduced Characters";
  static const String activeCharactersTitle = "Active Characters";
  static const String exitedCharactersTitle = "Exited Characters";

  const CharacterOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CharacterOverviewController(),
      builder: (context, child) => _buildCharacterOverview(context),
    );
  }

  Widget _buildCharacterOverview(BuildContext context) {
    return Row(
      children: [
        _buildCharactersNotIntroducedColumn(),
        _buildActiveCharactersColumn(),
        _buildExitedCharactersColumn(),
      ],
    );
  }

  Widget _buildCharactersNotIntroducedColumn() {
    return const Expanded(
      child: CharactersColumn(title: unintroducedCharactersTitle),
    );
  }

  Widget _buildActiveCharactersColumn() {
    return const Expanded(
      child: CharactersColumn(title: activeCharactersTitle),
    );
  }

  Widget _buildExitedCharactersColumn() {
    return const Expanded(
      child: CharactersColumn(title: exitedCharactersTitle),
    );
  }
}
