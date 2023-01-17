import 'package:flutter/material.dart';

import 'display_field.dart';

class DisplayFieldWidget extends StatefulWidget {
  final DisplayField displayField;
  final ValueChanged<String> onChanged;

  DisplayFieldWidget({super.key, required this.displayField, onChanged})
      : onChanged = onChanged ?? (() {});

  @override
  State<DisplayFieldWidget> createState() => _DisplayFieldWidgetState();
}

class _DisplayFieldWidgetState extends State<DisplayFieldWidget> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    setText();
    return Row(
      children: [
        _buildFieldName(theme),
        _buildTextInputField(theme),
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

  SizedBox _buildTextInputField(ThemeData theme) {
    TextStyle fieldValueStyle = theme.textTheme.bodyMedium!;
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textController,
          style: fieldValueStyle,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (inputValue) {
            widget.onChanged(inputValue);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
