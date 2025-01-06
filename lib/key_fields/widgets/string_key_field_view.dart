import 'package:ceal_chronicler_f/key_fields/widgets/previous_key_button.dart';
import 'package:ceal_chronicler_f/key_fields/widgets/rename_string_key_button.dart';
import 'package:ceal_chronicler_f/key_fields/widgets/string_key_field_controller.dart';
import 'package:ceal_chronicler_f/key_fields/widgets/toggle_key_button.dart';
import 'package:ceal_chronicler_f/utils/string_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../string_key_field.dart';
import 'next_key_button.dart';

class StringKeyFieldView extends StatelessWidget {
  final StringKeyField keyField;

  StringKeyFieldView(this.keyField) : super(key: StringKey(keyField.id.uuid));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StringKeyFieldController(keyField),
      builder: (context, child) => _buildView(context),
    );
  }

  Widget _buildView(BuildContext context) {
    return Row(
      children: [
        _buildPreviousKeyButton(context),
        _buildAddOrRemoveKeyButton(context),
        _buildNextKeyButton(context),
        _buildCurrentValueText(context),
        _buildEditButton(context),
      ],
    );
  }

  Widget _buildPreviousKeyButton(BuildContext context) {
    var controller = context.read<StringKeyFieldController>();
    bool enabled = context.watch<StringKeyFieldController>().hasPrevious;
    return PreviousKeyButton(controller, enabled);
  }

  Widget _buildNextKeyButton(BuildContext context) {
    var controller = context.read<StringKeyFieldController>();
    bool enabled = context.watch<StringKeyFieldController>().hasNext;
    return NextKeyButton(controller, enabled);
  }

  Widget _buildAddOrRemoveKeyButton(BuildContext context) {
    var controller = context.read<StringKeyFieldController>();
    bool keyExistsAtCurrentPointInTime =
        context.watch<StringKeyFieldController>().keyExistsAtCurrentPointInTime;
    return ToggleKeyButton(controller, keyExistsAtCurrentPointInTime);
  }

  Widget _buildCurrentValueText(BuildContext context) {
    String value = context.watch<StringKeyFieldController>().currentValue ?? "";
    return Text(value);
  }

  Widget _buildEditButton(BuildContext context) {
    var controller = context.read<StringKeyFieldController>();
    return RenameStringKeyButton(controller);
  }
}
