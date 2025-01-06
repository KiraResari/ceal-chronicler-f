import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/model/temporal_entity.dart';
import '../../utils/string_key.dart';
import '../../utils/widgets/reorderable_list_controller.dart';
import '../model/temporal_attribute.dart';
import 'delete_temporal_attribute_button.dart';
import 'move_attribute_down_button.dart';
import 'move_attribute_up_button.dart';

class TemporalAttributeControls extends StatelessWidget {
  final TemporalAttribute attribute;
  final TemporalEntity entity;

  TemporalAttributeControls(this.entity, this.attribute)
      : super(key: StringKey(attribute.id.uuid));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReorderableListController<TemporalAttribute>(
          entity.temporalAttributes, attribute),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    bool canAttributeBeMovedUp = context
        .watch<ReorderableListController<TemporalAttribute>>()
        .canAttributeBeMovedUp;
    bool canAttributeBeMovedDown = context
        .watch<ReorderableListController<TemporalAttribute>>()
        .canAttributeBeMovedDown;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MoveAttributeUpButton(
            entity.temporalAttributes, attribute, canAttributeBeMovedUp),
        MoveAttributeDownButton(
            entity.temporalAttributes, attribute, canAttributeBeMovedDown),
        DeleteTemporalAttributeButton(entity, attribute),
      ],
    );
  }
}
