import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../custom_colors.dart';
import '../events/open_character_selection_view_event.dart';
import '../fields/display_field.dart';
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
            _buildFields(character, context),
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
      character.getDisplayValue(),
      style: titleStyle,
    );
  }

  Widget _buildFields(Character character, BuildContext context) {
    List<Widget> fields = [];
    for (var displayField in character.displayFields) {
      var fieldWidget = _buildField(displayField, context);
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

  Widget _buildField(DisplayField displayField, BuildContext context) {
    var theme = Theme.of(context);
    TextStyle fieldNameStyle = theme.textTheme.bodyLarge!;
    TextStyle fieldValueStyle = theme.textTheme.bodyMedium!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayField.fieldName,
          style: fieldNameStyle,
        ),
        Text(
          displayField.getDisplayValue(),
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
