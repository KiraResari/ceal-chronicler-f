import 'dart:io';

import 'package:ceal_chronicler_f/main_view/main_view_candidate.dart';
import 'package:flutter/material.dart';

import '../characters/widgets/character_overview.dart';
import '../incidents/widgets/incident_overview.dart';

class OverviewView extends MainViewCandidate {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Column(children: _buildChildren());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    return [
      const IncidentOverview(),
      const SizedBox(width: 50, height: 10,),
      const CharacterOverview(),
    ];
  }
}
