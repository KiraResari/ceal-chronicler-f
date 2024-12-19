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
    return controller.charactersAtActivePointInTime;
  }

  @override
  Widget buildItem(Character character) {
    return CharacterButton(character);
  }

  @override
  Widget buildAddButton() {
    return AddCharacterButton();
  }
}
