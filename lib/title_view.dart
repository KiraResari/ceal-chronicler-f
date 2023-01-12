import 'package:ceal_chronicler_f/events/open_character_selection_view_event.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import 'assetPaths/image_paths.dart';
import 'theme/custom_colors.dart';

class TitleView extends StatelessWidget {
  static const String welcomeMessage = "Welcome to the Ceal Chronicler f!";
  static const String startButtonText = "Go to Character Selection Screen";

  const TitleView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: CustomColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCealChroniclerImage(),
          _buildWelcomeText(theme),
          _buildStartButton(theme),
        ],
      ),
    );
  }

  _buildCealChroniclerImage() {
    return Image.asset(ImagePaths.logo);
  }

  Text _buildWelcomeText(ThemeData theme) {
    TextStyle textStyle = theme.textTheme.displaySmall!;
    return Text(
      welcomeMessage,
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }

  ElevatedButton _buildStartButton(ThemeData theme) {
    var eventBus = getIt.get<EventBus>();
    TextStyle buttonStyle = theme.textTheme.button!;

    return ElevatedButton(
      onPressed: () {
        eventBus.fire(OpenCharacterSelectionViewEvent());
      },
      child: Text(
        startButtonText,
        style: buttonStyle,
      ),
    );
  }
}
