import 'package:ceal_chronicler_f/main_view/main_view_candidate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/character_id.dart';
import 'character_view_controller.dart';

class CharacterView extends MainViewCandidate {
  final CharacterId id;

  const CharacterView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CharacterViewController(id),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    bool characterFound =
        context.watch<CharacterViewController>().characterFound;
    if (characterFound) {
      return _buildCharacterTable(context);
    } else {
      return Text("Character with ID ${id.readableString} was not found");
    }
  }

  Table _buildCharacterTable(BuildContext context) {
    return Table(
      children: [
        _buildNameRow(context),
        _buildFirstAppearanceRow(context),
      ],
    );
  }

  TableRow _buildNameRow(BuildContext context) {
    String name = context.watch<CharacterViewController>().name;
    return TableRow(children: [
      const Text("Name"),
      Text(name),
    ]);
  }

  TableRow _buildFirstAppearanceRow(BuildContext context) {
    String firstApperance =
        context.watch<CharacterViewController>().firstApperance;
    return TableRow(children: [
      const Text("First Appearance"),
      Text(firstApperance),
    ]);
  }
}
