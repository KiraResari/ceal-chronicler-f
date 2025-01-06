import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/model/temporal_entity.dart';
import '../../utils/string_key.dart';
import '../model/attribute.dart';
import '../../utils/widgets/reorderable_list_controller.dart';
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
      create: (context) =>
          ReorderableListController<Attribute>(entity.attributes, attribute),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    bool canAttributeBeMovedUp = context
        .watch<ReorderableListController<Attribute>>()
        .canAttributeBeMovedUp;
    bool canAttributeBeMovedDown = context
        .watch<ReorderableListController<Attribute>>()
        .canAttributeBeMovedDown;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        EditAttributeNameButton(attribute),
        MoveAttributeUpButton(
            entity.attributes, attribute, canAttributeBeMovedUp),
        MoveAttributeDownButton(
            entity.attributes, attribute, canAttributeBeMovedDown),
        DeleteAttributeButton(entity, attribute),
      ],
    );
  }
}
