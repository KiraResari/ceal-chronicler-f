import 'package:flutter/material.dart';

import '../characters/widgets/character_overview.dart';
import '../incidents/widgets/incident_overview.dart';
import '../locations/widgets/views/location_overview.dart';
import '../main_view/main_view_candidate.dart';

class OverviewView extends MainViewCandidate {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      const IncidentOverview(),
      const SizedBox(width: 50, height: 10,),
      const CharacterOverview(),
      const SizedBox(width: 50, height: 10,),
      const LocationOverview(),
    ];
  }
}
