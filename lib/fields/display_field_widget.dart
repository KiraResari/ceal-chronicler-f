import 'package:flutter/material.dart';

import 'display_field.dart';

class DisplayFieldWidget extends StatefulWidget {
  final DisplayField displayField;

  const DisplayFieldWidget({super.key, required this.displayField});

  @override
  State<DisplayFieldWidget> createState() => _DisplayFieldWidgetState();
}

class _DisplayFieldWidgetState extends State<DisplayFieldWidget> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle fieldNameStyle = theme.textTheme.bodyLarge!;
    TextStyle fieldValueStyle = theme.textTheme.bodyMedium!;
    textController.text = widget.displayField.getDisplayValue();
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 75,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${widget.displayField.fieldName}: ",
                style: fieldNameStyle,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                style: fieldValueStyle,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
