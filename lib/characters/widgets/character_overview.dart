import 'package:ceal_chronicler_f/characters/widgets/delete_character_button.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/overview.dart';
import '../model/character.dart';
import 'add_character_button.dart';
import 'character_button.dart';
import 'character_overview_controller.dart';

class CharacterOverview
    extends Overview<Character, CharacterOverviewController> {
  const CharacterOverview({super.key});

  @override
  CharacterOverviewController createController() {
    return CharacterOverviewController();
  }

  @override
  Color get backgroundColor => Colors.green;

  @override
  String get title => "Characters";

  @override
  List<Character> getItems(CharacterOverviewController controller) {
    return controller.entitiesAtActivePointInTime;
  }

  @override
  Widget buildItem(Character item) {
    return Row(
      children: [
        CharacterButton(item),
        DeleteCharacterButton(item),
      ],
    );
  }

  @override
  Widget buildAddButton() {
    return AddCharacterButton();
  }
}
