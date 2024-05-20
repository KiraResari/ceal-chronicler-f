import 'package:ceal_chronicler_f/main_view/main_view_candidate.dart';
import 'package:flutter/material.dart';

import '../characters/widgets/character_overview.dart';
import '../incidents/widgets/incident_overview.dart';

class OverviewView extends MainViewCandidate {
  const OverviewView({super.key});

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
