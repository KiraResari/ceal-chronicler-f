import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_colors.dart';
import '../app_state.dart';
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

  Column _buildMainColumn(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;
    return Column(
      children: [
        Text(
          "Characters",
          style: titleStyle,
        ),
        Column(children: _buildCharacterCards(context)),
      ],
    );
  }

  List<Card> _buildCharacterCards(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Character> characters = appState.getCharacters();

    List<Card> characterCards = [];
    for (var character in characters) {
      var card = _buildCharacterCard(character, context);
      characterCards.add(card);
    }
    return characterCards;
  }

  Card _buildCharacterCard(Character character, BuildContext context) {
    var theme = Theme.of(context);
    TextStyle buttonStyle = theme.textTheme.button!;
    return Card(
      color: theme.colorScheme.primary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          character.name,
          style: buttonStyle,
        ),
      ),
    );
  }
}
