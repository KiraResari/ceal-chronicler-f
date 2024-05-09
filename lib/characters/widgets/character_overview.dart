import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/title_medium.dart';
import '../model/character.dart';
import 'character_overview_controller.dart';
import 'character_panel.dart';
import 'add_character_button.dart';

class CharacterOverview extends StatelessWidget {
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
      children: _buildContentElements(context),
    );
  }

  List<Widget> _buildContentElements(BuildContext context) {
    List<Widget> contentElements = [];
    contentElements.add(const TitleMedium(title: "Characters"));
    contentElements.addAll(_buildCharacterPanels(context));
    contentElements.add(AddCharacterButton());
    return contentElements;
  }

  List<Widget> _buildCharacterPanels(BuildContext context) {
    var controller = context.watch<CharacterOverviewController>();
    List<Widget> incidentTiles = [];
    for (Character character in controller.charactersAtActivePointInTime) {
      incidentTiles.add(CharacterPanel(character));
    }
    return incidentTiles;
  }
}
