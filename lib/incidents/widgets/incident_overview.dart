import 'package:ceal_chronicler_f/incidents/widgets/add_incident_button.dart';
import 'package:ceal_chronicler_f/incidents/widgets/incident_panel.dart';
import 'package:ceal_chronicler_f/utils/widgets/title_medium.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/incident.dart';
import 'incident_overview_controller.dart';

class IncidentOverview extends StatelessWidget {
  const IncidentOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IncidentOverviewController(),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.yellow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: _buildContentElements(context),
        ),
      ),
    );
  }

  List<Widget> _buildContentElements(BuildContext context) {
    List<Widget> contentElements = [];
    contentElements.add(const TitleMedium(title: "Incidents"));
    contentElements.addAll(_buildIncidentPanels(context));
    contentElements.add(const AddIncidentButton());
    return contentElements;
  }

  List<Widget> _buildIncidentPanels(BuildContext context) {
    var controller = context.watch<IncidentOverviewController>();
    List<Widget> incidentTiles = [];
    for (Incident incident in controller.incidentsAtActivePointInTime) {
      incidentTiles.add(IncidentPanel(incident));
    }
    return incidentTiles;
  }
}
