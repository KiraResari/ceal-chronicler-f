import 'package:ceal_chronicler_f/attributes/model/attribute.dart';
import 'package:ceal_chronicler_f/attributes/widgets/add_attribute_button.dart';
import 'package:ceal_chronicler_f/attributes/widgets/attribute_panel.dart';
import 'package:ceal_chronicler_f/attributes/widgets/edit_attribute_label_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../key_fields/string_key_field.dart';
import '../../key_fields/widgets/string_key_field_view.dart';
import '../../main_view/main_view_candidate.dart';
import '../../overview_view/return_to_overview_view_button.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../model/temporal_entity.dart';
import 'buttons/delete_button.dart';
import 'buttons/goto_point_in_time_button.dart';
import 'temporal_entity_view_controller.dart';

abstract class TemporalEntityView<T extends TemporalEntity,
    C extends TemporalEntityViewController<T>> extends MainViewCandidate {
  final T entity;

  const TemporalEntityView({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => createController(),
      builder: (context, child) => _buildPaddedContent(context),
    );
  }

  C createController();

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
        _buildTitleRow(context),
        _buildBody(context),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.titleMedium!;
    String name = context.watch<C>().name;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ReturnToOverviewViewButton(),
          Text(name, style: style),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<Widget> columns = [
      buildEntityTable(
        context,
        _buildEntityTableChildren(context),
      )
    ];
    columns.add(_buildAttributeColumn(context));
    columns.addAll(buildAdditionalColumns(context));
    ScrollController controller = ScrollController();

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columns,
        ),
      ),
    );
  }

  Table buildEntityTable(BuildContext context, List<TableRow> children) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: children,
    );
  }

  List<TableRow> _buildEntityTableChildren(BuildContext context) {
    StringKeyField nameField = context.watch<C>().nameField;
    var children = [
      buildNamedTableRow(context, "Name", StringKeyFieldView(nameField)),
      buildNamedTableRow(
          context, "First Appearance", _buildFirstAppearanceBlock(context)),
      buildNamedTableRow(
          context, "Last Appearance", _buildLastAppearanceBlock(context)),
    ];
    children.addAll(buildAdditionalEntityTableChildren(context));
    return children;
  }

  List<TableRow> buildAdditionalEntityTableChildren(BuildContext context) => [];

  TableRow buildNamedTableRow(
    BuildContext context,
    String label,
    Widget secondCell,
  ) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.labelMedium!;
    var firstCell = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(label, style: style, textAlign: TextAlign.end),
    );
    return TableRow(
      children: [
        firstCell,
        secondCell,
      ],
    );
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
    var controller = context.read<C>();
    PointInTime? firstAppearance = context.watch<C>().firstAppearance;
    List<PointInTime> validFirstAppearances =
        context.watch<C>().validFirstAppearances;
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

  Widget _buildGotoFirstAppearanceButton(BuildContext context) {
    PointInTimeId firstAppearance = context.watch<C>().entity.firstAppearance;
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
    if (entity.lastAppearance != null) {
      lastAppearanceBlockElements.add(DeleteButton(
        onPressedFunction: () => _onDeleteLastAppearanceButtonPressed(context),
        tooltip: "Delete last appearance",
      ));
    }
    return Row(children: lastAppearanceBlockElements);
  }

  Widget _buildLastAppearanceDropdown(BuildContext context) {
    var controller = context.read<C>();
    PointInTime? lastAppearance = context.watch<C>().lastAppearance;
    List<PointInTime> validLastAppearances =
        context.watch<C>().validLastAppearances;
    List<DropdownMenuEntry<PointInTime>> entries =
        _buildPointInTimeDropdownMenuEntryList(validLastAppearances);

    return DropdownMenu<PointInTime>(
      initialSelection: lastAppearance,
      dropdownMenuEntries: entries,
      onSelected: (PointInTime? point) {
        controller.updateLastAppearance(point);
      },
    );
  }

  Widget _buildGotoLastAppearanceButton(BuildContext context) {
    PointInTimeId? lastAppearance = context.watch<C>().entity.lastAppearance;
    return GotoPointInTimeButton(
      icon: Icons.arrow_right,
      pointInTimeId: lastAppearance,
      referenceName: "last appearance",
    );
  }

  void _onDeleteLastAppearanceButtonPressed(BuildContext context) {
    var controller = context.read<C>();
    controller.deleteLastAppearance();
  }

  List<DropdownMenuEntry<PointInTime>> _buildPointInTimeDropdownMenuEntryList(
      List<PointInTime> pointInTimeList) {
    return pointInTimeList
        .map<DropdownMenuEntry<PointInTime>>((PointInTime point) {
      return DropdownMenuEntry<PointInTime>(
        value: point,
        label: point.name,
      );
    }).toList();
  }

  Widget _buildAttributeColumn(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.titleMedium!;
    return Column(
      children: [
        Text(
          "Permanent Attributes",
          style: style,
        ),
        _buildAttributeTable(context),
        AddAttributeButton(entity),
      ],
    );
  }

  Widget _buildAttributeTable(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildAttributeTableRows(context),
    );
  }

  List<TableRow> _buildAttributeTableRows(BuildContext context) {
    List<Attribute> attributes = context.watch<C>().attributes;
    return attributes
        .map((attribute) => _buildAttributeTableRow(context, attribute))
        .toList();
  }

  TableRow _buildAttributeTableRow(BuildContext context, Attribute attribute) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.labelMedium!;
    var firstCell = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        EditAttributeLabelButton(attribute),
        Text(attribute.label, style: style, textAlign: TextAlign.end),
        const SizedBox(width: 5),
      ],
    );
    return TableRow(
      children: [
        firstCell,
        Text(attribute.name),
        AttributeControls(entity, attribute),
      ],
    );
  }

  List<Widget> buildAdditionalColumns(BuildContext context) => [];
}
