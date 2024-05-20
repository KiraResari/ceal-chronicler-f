import 'package:ceal_chronicler_f/main_view/main_view_candidate.dart';
import 'package:ceal_chronicler_f/overview_view/return_to_overview_view_button.dart';
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
      builder: (context, child) => _buildPaddedContent(context),
    );
  }

  Widget _buildPaddedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    bool characterFound =
        context.watch<CharacterViewController>().characterFound;
    if (characterFound) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          _buildCharacterTable(context),
          ReturnToOverviewViewButton(),
        ],
      );
    } else {
      return Text("Character with ID ${id.readableString} was not found");
    }
  }

  _buildTitle(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.titleMedium!;
    String name = context.watch<CharacterViewController>().name;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        name,
        style: style,
      ),
    );
  }

  Table _buildCharacterTable(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
      },
      children: [
        _buildTableRow(context, "Name", _buildNameField(context)),
        _buildTableRow(
          context,
          "First Appearance",
          _buildFirstAppearanceField(context),
        ),
      ],
    );
  }

  TableRow _buildTableRow(BuildContext context, String label, Widget child) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.labelMedium!;
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: style,
          textAlign: TextAlign.end,
        ),
      ),
      child,
    ]);
  }

  Widget _buildNameField(BuildContext context) {
    String name = context.watch<CharacterViewController>().name;
    return Text(name);
  }

  Widget _buildFirstAppearanceField(BuildContext context) {
    String firstApperance =
        context.watch<CharacterViewController>().firstApperance;
    return Text(firstApperance);
  }
}
