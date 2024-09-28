import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../key_fields/string_key_field.dart';
import '../../key_fields/widgets/string_key_field_view.dart';
import '../../main_view/main_view_candidate.dart';
import '../../overview_view/return_to_overview_view_button.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../model/character.dart';
import 'character_view_controller.dart';
import 'delete_last_appearance_button.dart';
import 'goto_point_in_time_button.dart';

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
        _buildTableRow(
          context,
          "Last Appearance",
          _buildLastAppearanceBlock(context),
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
    List<DropdownMenuEntry<PointInTime>> entries =
        _buildPointInTimeDropdownMenuEntryList(validFirstAppearances);
    return DropdownMenu<PointInTime>(
      initialSelection: firstAppearance,
      dropdownMenuEntries: entries,
      onSelected: (PointInTime? point) {
        controller.updateFirstAppearance(point);
      },
    );
  }

  List<DropdownMenuEntry<PointInTime>> _buildPointInTimeDropdownMenuEntryList(
    List<PointInTime> pointInTimeList,
  ) {
    return pointInTimeList
        .map<DropdownMenuEntry<PointInTime>>((PointInTime point) {
      return DropdownMenuEntry<PointInTime>(
        value: point,
        label: point.name,
      );
    }).toList();
  }

  Widget _buildGotoFirstAppearanceButton(BuildContext context) {
    PointInTimeId firstAppearance =
        context.watch<CharacterViewController>().character.firstAppearance;
    return GotoPointInTimeButton(
      icon: Icons.arrow_left,
      pointInTimeId: firstAppearance,
      referenceName: "first appearance",
    );
  }

  Widget _buildLastAppearanceBlock(BuildContext context) {
    List<Widget> lastAppearanceBlockElements = [
      _buildLastAppearanceDropdown(context),
      _buildGotoLastAppearanceButton(context),
    ];
    if (character.lastAppearance != null) {
      lastAppearanceBlockElements
          .add(DeleteLastAppearanceButton(character: character));
    }
    return Row(
      children: lastAppearanceBlockElements,
    );
  }

  Widget _buildLastAppearanceDropdown(BuildContext context) {
    var controller = context.read<CharacterViewController>();
    PointInTime? lastAppearance =
        context.watch<CharacterViewController>().lastAppearance;
    List<PointInTime> validLastAppearances =
        context.watch<CharacterViewController>().validLastAppearances;
    List<DropdownMenuEntry<PointInTime>> entries =
        _buildPointInTimeDropdownMenuEntryList(validLastAppearances);
    var dropdownMenu = DropdownMenu<PointInTime>(
      initialSelection: lastAppearance,
      dropdownMenuEntries: entries,
      onSelected: (PointInTime? point) {
        controller.updateLastAppearance(point);
      },
    );

    return dropdownMenu;
  }

  Widget _buildGotoLastAppearanceButton(BuildContext context) {
    PointInTimeId? lastAppearance =
        context.watch<CharacterViewController>().character.lastAppearance;
    return GotoPointInTimeButton(
      icon: Icons.arrow_right,
      pointInTimeId: lastAppearance,
      referenceName: "last appearance",
    );
  }
}
