import 'package:ceal_chronicler_f/incidents/widgets/add_incident_button.dart';
import 'package:ceal_chronicler_f/incidents/widgets/incident_panel.dart';
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
    return Column(
      children: _buildContentElements(context),
    );
  }

  List<Widget> _buildContentElements(BuildContext context) {
    List<Widget> contentElements = [];
    contentElements.add(_buildTitle(context));
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

  Center _buildTitle(BuildContext context) {
    String activePointInTimeName =
        context.watch<IncidentOverviewController>().activePointInTimeName;
    TextStyle style = Theme.of(context).textTheme.headlineSmall!;
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text("Incidents at $activePointInTimeName", style: style),
      ),
    );
  }
}
