import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_colors.dart';
import '../app_state.dart';
import '../events/open_character_view_event.dart';
import '../get_it_context.dart';
import 'character.dart';

class CharacterSelectionView extends StatelessWidget {
  const CharacterSelectionView({super.key});

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
            "Characters",
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
    var appState = context.watch<AppState>();
    List<Character> characters = appState.getCharacters();

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
