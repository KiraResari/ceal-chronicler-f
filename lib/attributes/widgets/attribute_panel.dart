import 'package:ceal_chronicler_f/utils/string_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/model/temporal_entity.dart';
import '../model/attribute.dart';
import 'attribute_panel_controller.dart';
import 'delete_attribute_button.dart';
import 'edit_attribute_name_button.dart';
import 'move_attribute_down_button.dart';
import 'move_attribute_up_button.dart';

class AttributeControls extends StatelessWidget {
  final Attribute attribute;
  final TemporalEntity entity;

  AttributeControls(this.entity, this.attribute)
      : super(key: StringKey(attribute.id.uuid));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AttributeControlsController(entity, attribute),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    bool canAttributeBeMovedUp =
        context.watch<AttributeControlsController>().canAttributeBeMovedUp;
    bool canAttributeBeMovedDown =
        context.watch<AttributeControlsController>().canAttributeBeMovedDown;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        EditAttributeNameButton(attribute),
        MoveAttributeUpButton(entity, attribute, canAttributeBeMovedUp),
        MoveAttributeDownButton(entity, attribute, canAttributeBeMovedDown),
        DeleteAttributeButton(entity, attribute),
      ],
    );
  }
}
