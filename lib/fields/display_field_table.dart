import 'package:flutter/cupertino.dart';

import '../utils/text_size_getter.dart';
import 'display_field.dart';
import 'display_field_row.dart';

class DisplayFieldTable extends StatelessWidget {
  final List<DisplayField> displayFields;
  final Function(String, DisplayField) onChanged;
  final TextStyle? fieldNameStyle;
  final TextStyle? fieldValueStyle;

  DisplayFieldTable({
    required this.displayFields,
    onChanged,
    this.fieldNameStyle,
    this.fieldValueStyle,
    super.key,
  }) : onChanged = onChanged ?? (() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildDisplayFieldRows(context),
    );
  }

  List<Widget> _buildDisplayFieldRows(BuildContext context) {
    double nameFieldWidth = _determineBiggestNameFieldWidth(context);
    List<Widget> rows = [];
    for (var displayField in displayFields) {
      var row = DisplayFieldRow(
        displayField: displayField,
        onChanged: (inputValue) {
          onChanged(inputValue, displayField);
        },
        nameFieldWidth: nameFieldWidth,
      );
      rows.add(row);
    }
    return rows;
  }

  double _determineBiggestNameFieldWidth(BuildContext context) {
    double biggestFoundFieldWidth = 0;
    for (var displayField in displayFields) {
      double fieldWidth = TextSizeGetter.getTextWidth(
        displayField.fieldName,
        fieldNameStyle,
        context,
      );
      if (fieldWidth > biggestFoundFieldWidth) {
        biggestFoundFieldWidth = fieldWidth;
      }
    }
    return biggestFoundFieldWidth;
  }
}
