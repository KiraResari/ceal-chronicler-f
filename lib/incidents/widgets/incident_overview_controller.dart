import 'package:ceal_chronicler_f/incidents/model/incident_id.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../../commands/command_processor.dart';
import '../model/incident.dart';

class IncidentOverviewController extends ChangeNotifier {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _incidentRepository = getIt.get<IncidentRepository>();
  final _commandProcessor = getIt.get<CommandProcessor>();

  IncidentOverviewController() {
    _pointInTimeRepository.addListener(_notifyListenersCall);
    _commandProcessor.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  @override
  void dispose() {
    super.dispose();
    _pointInTimeRepository.removeListener(_notifyListenersCall);
    _commandProcessor.removeListener(_notifyListenersCall);
  }

  String get activePointInTimeName => activePointInTime.name;

  PointInTime get activePointInTime => _pointInTimeRepository.activePointInTime;

  List<Incident> get incidentsAtActivePointInTime {
    return _incidentRepository
        .getContentElementsById(activePointIncidentReferences);
  }

  List<IncidentId> get activePointIncidentReferences =>
      activePointInTime.incidentReferences;

  bool canIncidentBeMovedUp(Incident incident) {
    return activePointIncidentReferences.contains(incident.id) &&
        activePointIncidentReferences.first != incident.id;
  }

  bool canIncidentBeMovedDown(Incident incident) {
    return activePointIncidentReferences.contains(incident.id) &&
        activePointIncidentReferences.last != incident.id;
  }
}
