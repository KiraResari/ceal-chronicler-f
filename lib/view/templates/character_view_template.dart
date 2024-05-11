import 'package:ceal_chronicler_f/characters/widgets/character_view.dart';
import 'package:ceal_chronicler_f/view/templates/view_template.dart';
import 'package:flutter/material.dart';

import '../../characters/model/character_id.dart';

class CharacterViewTemplate extends ViewTemplate {
  final CharacterId id;

  CharacterViewTemplate(this.id);

  @override
  Widget get associatedView => CharacterView(id: id);
}
