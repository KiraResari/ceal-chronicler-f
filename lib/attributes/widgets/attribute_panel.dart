import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/model/temporal_entity.dart';
import '../model/attribute.dart';
import 'attribute_panel_controller.dart';
import 'delete_attribute_button.dart';
import 'edit_attribute_button.dart';
import 'move_attribute_down_button.dart';
import 'move_attribute_up_button.dart';

class AttributePanel extends StatelessWidget {
  final Attribute attribute;
  final TemporalEntity entity;

  const AttributePanel(this.entity, this.attribute, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AttributePanelController(entity, attribute),
      builder: (context, child) => _buildContent(context),
    );
  }

  Card _buildContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color cardColor = theme.colorScheme.inversePrimary;
    return Card(
      color: cardColor,
      child: _buildTextAndButtons(context),
    );
  }

  Row _buildTextAndButtons(BuildContext context) {
    bool canAttributeBeMovedUp =
        context.watch<AttributePanelController>().canAttributeBeMovedUp;
    bool canAttributeBeMovedDown =
        context.watch<AttributePanelController>().canAttributeBeMovedDown;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attribute.name),
        ),
        EditAttributeButton(attribute),
        MoveAttributeUpButton(entity, attribute, canAttributeBeMovedUp),
        MoveAttributeDownButton(entity, attribute, canAttributeBeMovedDown),
        DeleteAttributeButton(entity, attribute),
      ],
    );
  }
}
