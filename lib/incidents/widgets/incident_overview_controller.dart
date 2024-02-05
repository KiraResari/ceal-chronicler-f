import 'package:ceal_chronicler_f/incidents/model/incident_id.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
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

  String get activePointInTimeName =>
      _pointInTimeRepository.activePointInTime.name;

  List<Incident> get incidentsAtActivePointInTime {
    List<IncidentId> incidentReferences =
        _pointInTimeRepository.activePointInTime.incidentReferences;
    return _incidentRepository.getIncidentsByReference(incidentReferences);
  }
}
