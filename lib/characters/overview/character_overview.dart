import 'package:ceal_chronicler_f/utils/widgets/title_medium.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'character_overview_controller.dart';

class CharacterOverview extends StatelessWidget {
  static const String unintroducedCharactersTitle = "Unintroduced Characters";
  static const String activeCharactersTitle = "Active Characters";
  static const String exitedCharactersTitle = "Exited Characters";

  const CharacterOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CharacterOverviewController(),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildCharacterOverview(context),
      ),
    );
  }

  Widget _buildCharacterOverview(BuildContext context) {
    return Column(
      children: [
        const TitleMedium(title: "Characters"),
      ],
    );
  }
}
