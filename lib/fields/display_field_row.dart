import 'package:flutter/material.dart';

import 'display_field.dart';

class DisplayFieldRow extends StatefulWidget {
  final DisplayField displayField;
  final ValueChanged<String> onChanged;
  final double nameFieldWidth;
  final TextStyle? fieldNameStyle;
  final TextStyle? fieldValueStyle;

  DisplayFieldRow({
    required this.displayField,
    onChanged,
    nameFieldWidth,
    this.fieldNameStyle,
    this.fieldValueStyle,
    super.key,
  })  : onChanged = onChanged ?? (() {}),
        nameFieldWidth = nameFieldWidth ?? 75;

  @override
  State<DisplayFieldRow> createState() => _DisplayFieldRowState();
}

class _DisplayFieldRowState extends State<DisplayFieldRow> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setText();
    return Row(
      children: [
        _buildFieldName(),
        _buildWrappedInputField(),
      ],
    );
  }

  void setText() {
    if (textController.text != widget.displayField.getDisplayValue()) {
      textController.text = widget.displayField.getDisplayValue();
    }
  }

  SizedBox _buildFieldName() {
    return SizedBox(
      width: widget.nameFieldWidth,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          widget.displayField.fieldName,
          style: widget.fieldNameStyle,
        ),
      ),
    );
  }

  Widget _buildWrappedInputField() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: _buildBareInputField(),
      ),
    );
  }

  TextField _buildBareInputField() {
    return TextField(
      controller: textController,
      style: widget.fieldValueStyle,
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
