import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../custom_colors.dart';
import '../events/open_character_selection_view_event.dart';
import '../get_it_context.dart';
import '../theme/button_styles.dart';
import 'character.dart';

class CharacterView extends StatelessWidget {
  final Character character;

  const CharacterView({super.key, required this.character});

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
            _buildField("Species", character.species, context),
            _buildField("Weapon", character.weapon, context),
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
      character.name,
      style: titleStyle,
    );
  }

  Widget _buildField(
      String fieldName, String fieldValue, BuildContext context) {
    var theme = Theme.of(context);
    TextStyle fieldNameStyle = theme.textTheme.bodyLarge!;
    TextStyle fieldValueStyle = theme.textTheme.bodyMedium!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$fieldName: ",
          style: fieldNameStyle,
        ),
        Text(
          fieldValue,
          style: fieldValueStyle,
        ),
      ],
    );
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
        "↩ Back",
        style: buttonTextStyle,
      ),
    );
  }
}
