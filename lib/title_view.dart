import 'package:ceal_chronicler_f/events/open_character_selection_view_event.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_colors.dart';
import 'app_state.dart';

class TitleView extends StatelessWidget {
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
          _buildStartButton(theme, context),
        ],
      ),
    );
  }

  _buildCealChroniclerImage() {
    return Image.asset("assets/images/CealChroniclerLogo.png");
  }

  Text _buildWelcomeText(ThemeData theme) {
    TextStyle textStyle = theme.textTheme.displaySmall!;
    return Text(
      "Welcome to the Ceal Chronicler f!",
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }

  ElevatedButton _buildStartButton(ThemeData theme, BuildContext context) {
    var eventBus = getIt.get<EventBus>();

    return ElevatedButton(
      onPressed: () {
        eventBus.fire(OpenCharacterSelectionViewEvent());
      },
      child: const Text("Go to Character Selection Screen"),
    );
  }
}
