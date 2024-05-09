import 'package:flutter/material.dart';

import 'characters/widgets/character_overview.dart';
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
