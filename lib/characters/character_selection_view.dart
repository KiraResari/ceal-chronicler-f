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
      child: Column(
        children: _buildCharacterCards(context),
      ),
    );
  }

  List<Card> _buildCharacterCards(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Character> characters = appState.getCharacters();

    List<Card> characterCards = [];
    for (var character in characters) {
      var card = Card(child: Text(character.name));
      characterCards.add(card);
    }
    return characterCards;
  }
}
