import 'dart:async';

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
  static const backWithoutSavingButtonText = "$backButtonText (without saving)";
  static const saveButtonText = "💾 Save";
  static const resetButtonText = "✖ Reset";

  final Character character;
  final Character originalCharacter;

  CharacterView({super.key, required this.character})
      : originalCharacter = character.copy();

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  final _eventBus = getIt.get<EventBus>();
  late final StreamSubscription<UpdateCharacterViewEvent>
      _onUpdateCharacterViewEventSubscription;

  _CharacterViewState() {
    _onUpdateCharacterViewEventSubscription =
        _eventBus.on<UpdateCharacterViewEvent>().listen((event) {
      _updateView();
    });
  }

  @override
  dispose() {
    super.dispose();
    _onUpdateCharacterViewEventSubscription.cancel();
  }

  _updateView() {
    widget.originalCharacter.copyValuesFrom(widget.character);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.background,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildMainColumn(context),
      ),
    );
  }

  Widget _buildMainColumn(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          _buildFields(widget.character, context),
          _buildButtonRow(context),
        ],
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
    if (widget.character == widget.originalCharacter) {
      buttons.add(_buildBackButton(context));
    } else {
      buttons.add(_buildBackWithoutSavingButton(context));
      buttons.add(_buildResetButton(context));
      buttons.add(const SizedBox(width: 50));
      buttons.add(_buildSaveButton(context));
    }
    return buttons;
  }

  Widget _buildBackButton(BuildContext context) {
    return _buildBackButtonBase(
      context,
      ButtonStyles.neutral,
      CharacterView.backButtonText,
    );
  }

  Widget _buildBackWithoutSavingButton(BuildContext context) {
    return _buildBackButtonBase(
      context,
      ButtonStyles.cancel,
      CharacterView.backWithoutSavingButtonText,
    );
  }

  Widget _buildBackButtonBase(
      BuildContext context, ButtonStyle buttonStyle, String text) {
    var eventBus = getIt.get<EventBus>();
    var theme = Theme.of(context);
    TextStyle buttonTextStyle = theme.textTheme.button!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: () {
          eventBus.fire(OpenCharacterSelectionViewEvent());
        },
        child: Text(
          text,
          style: buttonTextStyle,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    var eventBus = getIt.get<EventBus>();
    var theme = Theme.of(context);
    TextStyle buttonTextStyle = theme.textTheme.button!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyles.confirm,
        onPressed: () {
          eventBus.fire(SaveCharacterEvent(widget.character));
        },
        child: Text(
          CharacterView.saveButtonText,
          style: buttonTextStyle,
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle buttonTextStyle = theme.textTheme.button!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyles.cancel,
        onPressed: () {
          _discardChanges();
        },
        child: Text(
          CharacterView.resetButtonText,
          style: buttonTextStyle,
        ),
      ),
    );
  }

  void _discardChanges() {
    widget.character.copyValuesFrom(widget.originalCharacter);
    setState(() {});
  }
}
