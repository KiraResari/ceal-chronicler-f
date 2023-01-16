import 'package:ceal_chronicler_f/events/save_character_event.dart';
import 'package:ceal_chronicler_f/fields/display_field.dart';
import 'package:ceal_chronicler_f/fields/display_field_widget.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../events/open_character_selection_view_event.dart';
import '../events/update_character_view_event.dart';
import '../get_it_context.dart';
import '../theme/button_styles.dart';
import '../theme/custom_colors.dart';
import 'character.dart';

class CharacterView extends StatefulWidget {
  static const backButtonText = "↩ Back";
  static const saveButtonText = "💾 Save";

  final Character character;
  final Character originalCharacter;

  CharacterView({super.key, required this.character})
      : originalCharacter = character.copy();

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  final _eventBus = getIt.get<EventBus>();

  _CharacterViewState() {
    _eventBus.on<UpdateCharacterViewEvent>().listen((event) {
      _updateView();
    });
  }

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
            _buildButtonRow(context),
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
    if (inputValue != displayField.getDisplayValue()) {
      displayField.setValueFromString(inputValue);
    }
    setState(() {});
  }

  Widget _buildButtonRow(BuildContext context) {
    List<Widget> displayedButtons = _buildDisplayedButtons(context);
    return Row(children: displayedButtons);
  }

  List<Widget> _buildDisplayedButtons(BuildContext context) {
    List<Widget> buttons = [];
    buttons.add(_buildBackButton(context));
    if (widget.character != widget.originalCharacter) {
      buttons.add(_buildSaveButton(context));
    }
    return buttons;
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

  Widget _buildSaveButton(BuildContext context) {
    var eventBus = getIt.get<EventBus>();
    var theme = Theme.of(context);
    TextStyle buttonTextStyle = theme.textTheme.button!;

    return ElevatedButton(
      style: ButtonStyles.confirm,
      onPressed: () {
        eventBus.fire(SaveCharacterEvent(widget.character));
      },
      child: Text(
        CharacterView.saveButtonText,
        style: buttonTextStyle,
      ),
    );
  }

  _updateView() {
    widget.originalCharacter.copyValuesFrom(widget.character);
    setState(() {});
  }
}
