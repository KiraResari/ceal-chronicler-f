import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../custom_colors.dart';
import '../events/open_character_view_event.dart';
import '../get_it_context.dart';
import 'character.dart';
import 'character_selection_model.dart';

class CharacterSelectionView extends StatefulWidget {

  static const String titleText = "Characters";

  const CharacterSelectionView({super.key});

  @override
  State<CharacterSelectionView> createState() => _CharacterSelectionViewState();
}

class _CharacterSelectionViewState extends State<CharacterSelectionView> {

  var characterSelectionModel = getIt<CharacterSelectionModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.background,
      child: _buildMainColumn(context),
    );
  }

  Widget _buildMainColumn(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CharacterSelectionView.titleText,
            style: titleStyle,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildCharacterButtons(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCharacterButtons(BuildContext context) {
    List<Character> characters = characterSelectionModel.characters;

    List<Widget> characterButtons = [];
    for (var character in characters) {
      var button = _buildCharacterButton(character, context);
      characterButtons.add(button);
    }
    return characterButtons;
  }

  Widget _buildCharacterButton(Character character, BuildContext context) {
    var eventBus = getIt.get<EventBus>();
    var theme = Theme.of(context);
    TextStyle buttonStyle = theme.textTheme.button!;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () {
          eventBus.fire(OpenCharacterViewEvent(character));
        },
        child: Text(
          character.getDisplayValue(),
          style: buttonStyle,
        ),
      ),
    );
  }
}
