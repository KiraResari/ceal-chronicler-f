import 'package:ceal_chronicler_f/incidents/widgets/delete_incident_button.dart';
import 'package:ceal_chronicler_f/incidents/widgets/rename_incident_button.dart';
import 'package:flutter/material.dart';

import '../model/incident.dart';

class IncidentPanel extends StatelessWidget {
  final Incident incident;

  const IncidentPanel(this.incident, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color cardColor = theme.colorScheme.inversePrimary;
    return Card(
      color: cardColor,
      child: _buildTextAndButtons(),
    );
  }

  Row _buildTextAndButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(incident.name),
        ),
        RenameIncidentButton(incident),
        DeleteIncidentButton(incident),
      ],
    );
  }
}
