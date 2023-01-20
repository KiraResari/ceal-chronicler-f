import 'dart:async';

import 'package:ceal_chronicler_f/events/export_characters_event.dart';
import 'package:ceal_chronicler_f/events/import_characters_event.dart';
import 'package:ceal_chronicler_f/events/update_character_selection_view_event.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../events/add_character_event.dart';
import '../../theme/button_styles.dart';
import '../../theme/custom_colors.dart';
import '../../events/open_character_view_event.dart';
import '../../get_it_context.dart';
import '../character.dart';
import '../character_selection_view/character_selection_view_model.dart';

class CharacterSelectionView extends StatefulWidget {
  static const String titleText = "Characters";
  static const String addCharacterButtonText = "➕ Add Character";
  static const String saveButtonText = "💾 Save";
  static const String loadButtonText = "📁 Load";
  static final model = getIt<CharacterSelectionViewModel>();

  const CharacterSelectionView({super.key});

  @override
  State<CharacterSelectionView> createState() => _CharacterSelectionViewState();
}

class _CharacterSelectionViewState extends State<CharacterSelectionView> {
  List<Character> characters = CharacterSelectionView.model.characters;
  final _eventBus = getIt.get<EventBus>();
  late final StreamSubscription<UpdateCharacterSelectionViewEvent>
      _subscription;

  _CharacterSelectionViewState() {
    _subscription =
        _eventBus.on<UpdateCharacterSelectionViewEvent>().listen((event) {
      _updateCharacterSelectionView();
    });
  }

  @override
  dispose() {
    super.dispose();
    _subscription.cancel();
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
        _buildTitleText(context),
        _buildCharactersColumn(context),
        _buildActionButtonRow(context),
      ],
    );
  }

  Text _buildTitleText(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;
    return Text(
      CharacterSelectionView.titleText,
      style: titleStyle,
    );
  }

  Column _buildCharactersColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildCharacterButtons(context),
    );
  }

  List<Widget> _buildCharacterButtons(BuildContext context) {
    List<Widget> characterButtons = [];
    var index = 0;
    for (var character in characters) {
      var button = _buildCharacterButton(character, context, index);
      characterButtons.add(button);
      index++;
    }
    return characterButtons;
  }

  Widget _buildCharacterButton(
      Character character, BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => _onCharacterButtonPressed(character),
        child: _buildCharacterButtonText(character, context, index),
      ),
    );
  }

  void _onCharacterButtonPressed(Character character) {
    var eventBus = getIt.get<EventBus>();
    eventBus.fire(OpenCharacterViewEvent(character));
  }

  Text _buildCharacterButtonText(
      Character character, BuildContext context, int index) {
    var theme = Theme.of(context);
    TextStyle buttonStyle = theme.textTheme.button!;
    return Text(
      character.getDisplayValue(),
      style: buttonStyle,
      semanticsLabel: "Character Button $index",
    );
  }

  Widget _buildActionButtonRow(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        _buildAddCharacterButton(theme),
        _buildSaveButton(theme),
        _buildLoadButton(theme),
      ],
    );
  }

  Widget _buildAddCharacterButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyles.confirm,
        onPressed: () => _eventBus.fire(AddCharacterEvent()),
        child: _buildAddButtonText(theme),
      ),
    );
  }

  Text _buildAddButtonText(ThemeData theme) {
    TextStyle buttonTextStyle = theme.textTheme.button!;
    return Text(
      CharacterSelectionView.addCharacterButtonText,
      style: buttonTextStyle,
      semanticsLabel: "Add Character Button",
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyles.save,
        onPressed: () => _eventBus.fire(ExportCharactersEvent()),
        child: _buildSaveButtonText(theme),
      ),
    );
  }

  Text _buildSaveButtonText(ThemeData theme) {
    TextStyle buttonTextStyle = theme.textTheme.button!;
    return Text(
      CharacterSelectionView.saveButtonText,
      style: buttonTextStyle,
      semanticsLabel: "Save Button",
    );
  }

  Widget _buildLoadButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyles.load,
        onPressed: () => _eventBus.fire(ImportCharactersEvent()),
        child: _buildLoadButtonText(theme),
      ),
    );
  }

  Text _buildLoadButtonText(ThemeData theme) {
    TextStyle buttonTextStyle = theme.textTheme.button!;
    return Text(
      CharacterSelectionView.loadButtonText,
      style: buttonTextStyle,
      semanticsLabel: "Load Button",
    );
  }

  void _updateCharacterSelectionView() {
    setState(
      () {
        characters = CharacterSelectionView.model.characters;
      },
    );
  }
}
