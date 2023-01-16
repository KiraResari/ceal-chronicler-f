import 'package:ceal_chronicler_f/fields/display_field.dart';
import 'package:ceal_chronicler_f/fields/display_field_widget.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../events/open_character_selection_view_event.dart';
import '../get_it_context.dart';
import '../theme/button_styles.dart';
import '../theme/custom_colors.dart';
import 'character.dart';

class CharacterView extends StatefulWidget {
  static const backButtonText = "↩ Back";

  final Character character;

  const CharacterView({super.key, required this.character});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.background,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            _buildFields(widget.character, context),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Text _buildTitle(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;
    return Text(
      widget.character.getDisplayValue(),
      style: titleStyle,
    );
  }

  Widget _buildFields(Character character, BuildContext context) {
    List<Widget> fields = [];
    for (var displayField in character.displayFields) {
      var fieldWidget = DisplayFieldWidget(
        displayField: displayField,
        onChanged: (inputValue) {
          _handleInputFieldChange(inputValue, displayField);
        },
      );
      fields.add(fieldWidget);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields,
      ),
    );
  }

  void _handleInputFieldChange(String inputValue, DisplayField displayField) {
    if(inputValue != displayField.getDisplayValue()){
      displayField.setValueFromString(inputValue);
    }
  }

  Widget _buildBackButton(BuildContext context) {
    var eventBus = getIt.get<EventBus>();
    var theme = Theme.of(context);
    TextStyle buttonTextStyle = theme.textTheme.button!;

    return ElevatedButton(
      style: ButtonStyles.cancel,
      onPressed: () {
        eventBus.fire(OpenCharacterSelectionViewEvent());
      },
      child: Text(
        CharacterView.backButtonText,
        style: buttonTextStyle,
      ),
    );
  }
}
