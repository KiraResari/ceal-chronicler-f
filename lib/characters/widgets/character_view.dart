import 'package:ceal_chronicler_f/characters/widgets/goto_point_in_time_button.dart';
import 'package:ceal_chronicler_f/main_view/main_view_candidate.dart';
import 'package:ceal_chronicler_f/overview_view/return_to_overview_view_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../key_fields/string_key_field.dart';
import '../../key_fields/widgets/string_key_field_view.dart';
import '../../timeline/model/point_in_time.dart';
import '../model/character.dart';
import 'character_view_controller.dart';

class CharacterView extends MainViewCandidate {
  final Character character;

  const CharacterView({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CharacterViewController(character),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        _buildCharacterTable(context),
        ReturnToOverviewViewButton(),
      ],
    );
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
    StringKeyField name = context.watch<CharacterViewController>().nameField;
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
      },
      children: [
        _buildTableRow(
          context,
          "Name",
          StringKeyFieldView(name),
        ),
        _buildTableRow(
          context,
          "First Appearance",
          _buildFirstAppearanceBlock(context),
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

  Widget _buildFirstAppearanceBlock(BuildContext context) {
    return Row(
      children: [
        _buildFirstAppearanceDropdown(context),
        _buildGotoFirstAppearanceButton(context),
      ],
    );
  }

  Widget _buildFirstAppearanceDropdown(BuildContext context) {
    var controller = context.read<CharacterViewController>();
    PointInTime? firstAppearance =
        context.watch<CharacterViewController>().firstAppearance;
    List<PointInTime> validFirstAppearances =
        context.watch<CharacterViewController>().validFirstAppearances;
    List<DropdownMenuEntry<PointInTime>> entries = validFirstAppearances
        .map<DropdownMenuEntry<PointInTime>>((PointInTime point) {
      return DropdownMenuEntry<PointInTime>(
        value: point,
        label: point.name,
      );
    }).toList();
    return DropdownMenu<PointInTime>(
      initialSelection: firstAppearance,
      dropdownMenuEntries: entries,
      onSelected: (PointInTime? point) {
        controller.updateFirstAppearance(point);
      },
    );
  }

  Widget _buildGotoFirstAppearanceButton(BuildContext context) {
    PointInTime? firstAppearance =
        context.watch<CharacterViewController>().firstAppearance;
    if (firstAppearance == null) {
      return Text("No first apperance to go to");
    }
    return GotoPointInTimeButton(
      icon: Icons.arrow_left,
      pointInTimeId: firstAppearance.id,
      tooltip: "Go to first appearance",
      disabledReason: "Already at first appearance",
    );
  }
}
