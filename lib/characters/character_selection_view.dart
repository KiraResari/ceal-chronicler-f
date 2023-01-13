import 'package:ceal_chronicler_f/events/update_character_selection_view_event.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../events/add_character_event.dart';
import '../theme/button_styles.dart';
import '../theme/custom_colors.dart';
import '../events/open_character_view_event.dart';
import '../get_it_context.dart';
import 'character.dart';
import 'character_selection_model.dart';

class CharacterSelectionView extends StatefulWidget {
  static const String titleText = "Characters";
  static const String addCharacterButtonText = "Add Character";
  static final model = getIt<CharacterSelectionModel>();

  const CharacterSelectionView({super.key});

  @override
  State<CharacterSelectionView> createState() => _CharacterSelectionViewState();
}

class _CharacterSelectionViewState extends State<CharacterSelectionView> {
  List<Character> characters = CharacterSelectionView.model.characters;
  final _eventBus = getIt.get<EventBus>();

  _CharacterSelectionViewState() {
    _eventBus.on<UpdateCharacterSelectionViewEvent>().listen((event) {
      _updateCharacterSelectionView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.background,
      child: _buildMainColumn(context),
    );
  }

  Widget _buildMainColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(context),
          _buildCharactersColumn(context),
          _buildAddButton(context),
        ],
      ),
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
    for (var character in characters) {
      var button = _buildCharacterButton(character, context);
      characterButtons.add(button);
    }
    return characterButtons;
  }

  Widget _buildCharacterButton(Character character, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => _onCharacterButtonPressed(character),
        child: _buildCharacterButtonText(character, context),
      ),
    );
  }

  void _onCharacterButtonPressed(Character character) {
    var eventBus = getIt.get<EventBus>();
    eventBus.fire(OpenCharacterViewEvent(character));
  }

  Text _buildCharacterButtonText(Character character, BuildContext context) {
    var theme = Theme.of(context);
    TextStyle buttonStyle = theme.textTheme.button!;
    return Text(
      character.getDisplayValue(),
      style: buttonStyle,
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyles.confirm,
        onPressed: () => _onAddButtonPressed(),
        child: _buildAddButtonText(context),
      ),
    );
  }

  Text _buildAddButtonText(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle buttonTextStyle = theme.textTheme.button!;
    return Text(
      CharacterSelectionView.addCharacterButtonText,
      style: buttonTextStyle,
    );
  }

  void _onAddButtonPressed() {
    _eventBus.fire(AddCharacterEvent());
  }

  void _updateCharacterSelectionView() {
    setState(
      () {
        characters = CharacterSelectionView.model.characters;
      },
    );
  }
}
