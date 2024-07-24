import 'package:ceal_chronicler_f/key_fields/widgets/previous_key_button.dart';
import 'package:ceal_chronicler_f/key_fields/widgets/toggle_key_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'key_field_controller.dart';
import '../string_key_field.dart';
import 'next_key_button.dart';

class StringKeyFieldView extends StatelessWidget {
  final StringKeyField keyField;

  const StringKeyFieldView(this.keyField, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KeyFieldController<String>(keyField),
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
      ],
    );
  }

  Widget _buildPreviousKeyButton(BuildContext context) {
    KeyFieldController controller = context.read<KeyFieldController<String>>();
    bool enabled = context.watch<KeyFieldController<String>>().hasPrevious;
    return PreviousKeyButton(controller, enabled);
  }

  Widget _buildNextKeyButton(BuildContext context) {
    KeyFieldController controller = context.read<KeyFieldController<String>>();
    bool enabled = context.watch<KeyFieldController<String>>().hasPrevious;
    return NextKeyButton(controller, enabled);
  }

  Widget _buildAddOrRemoveKeyButton(BuildContext context) {
    KeyFieldController controller = context.read<KeyFieldController<String>>();
    bool keyExistsAtCurrentPointInTime = context
        .watch<KeyFieldController<String>>()
        .keyExistsAtCurrentPointInTime;
    return ToggleKeyButton(controller, keyExistsAtCurrentPointInTime);
  }

  Widget _buildCurrentValueText(BuildContext context) {
    String value = context.watch<KeyFieldController<String>>().currentValue;
    return Text(value);
  }
}
