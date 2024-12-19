import 'package:ceal_chronicler_f/incidents/widgets/add_incident_button.dart';
import 'package:ceal_chronicler_f/incidents/widgets/incident_panel.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/overview.dart';
import '../model/incident.dart';
import 'incident_overview_controller.dart';

class IncidentOverview extends Overview<Incident, IncidentOverviewController> {
  const IncidentOverview({super.key});

  @override
  IncidentOverviewController createController() {
    return IncidentOverviewController();
  }

  @override
  Color get backgroundColor => Colors.yellow;

  @override
  String get title => "Incidents";

  @override
  List<Incident> getItems(IncidentOverviewController controller) {
    return controller.incidentsAtActivePointInTime;
  }

  @override
  Widget buildItem(Incident incident) {
    return IncidentPanel(incident);
  }

  @override
  Widget buildAddButton() {
    return AddIncidentButton();
  }
}
