import 'package:ceal_chronicler_f/characters/overview/character_overview.dart';
import 'package:flutter/material.dart';

import 'incidents/widgets/incident_overview.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IncidentOverview(),
        SizedBox(width: 50),
        CharacterOverview(),
      ],
    );
  }
}
