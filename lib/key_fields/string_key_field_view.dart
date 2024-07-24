import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'key_field_controller.dart';
import 'string_key_field.dart';

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
    String value = context.watch<KeyFieldController<String>>().currentValue;
    return Text(value);
  }
}
