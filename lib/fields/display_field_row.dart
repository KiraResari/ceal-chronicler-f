import 'package:flutter/material.dart';

import 'display_field.dart';

class DisplayFieldRow extends StatefulWidget {
  final DisplayField displayField;
  final ValueChanged<String> onChanged;

  DisplayFieldRow({super.key, required this.displayField, onChanged})
      : onChanged = onChanged ?? (() {});

  @override
  State<DisplayFieldRow> createState() => _DisplayFieldRowState();
}

class _DisplayFieldRowState extends State<DisplayFieldRow> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    setText();
    return Row(
      children: [
        _buildFieldName(theme),
        _buildWrappedInputField(theme),
      ],
    );
  }

  void setText() {
    if (textController.text != widget.displayField.getDisplayValue()) {
      textController.text = widget.displayField.getDisplayValue();
    }
  }

  SizedBox _buildFieldName(ThemeData theme) {
    TextStyle fieldNameStyle = theme.textTheme.bodyLarge!;
    return SizedBox(
      width: 75,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "${widget.displayField.fieldName}: ",
          style: fieldNameStyle,
        ),
      ),
    );
  }

  Widget _buildWrappedInputField(ThemeData theme) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: _buildBareInputField(theme),
      ),
    );
  }

  TextField _buildBareInputField(ThemeData theme) {
    TextStyle fieldValueStyle = theme.textTheme.bodyMedium!;
    return TextField(
      controller: textController,
      style: fieldValueStyle,
      decoration: _buildInputFieldDecoration(),
      onChanged: (inputValue) {
        widget.onChanged(inputValue);
      },
    );
  }

  InputDecoration _buildInputFieldDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
