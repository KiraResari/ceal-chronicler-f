import '../../commands/processor_listener.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/incident.dart';
import '../model/incident_id.dart';
import '../model/incident_repository.dart';

class IncidentOverviewController extends ProcessorListener {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _incidentRepository = getIt.get<IncidentRepository>();

  IncidentOverviewController() : super() {
    _pointInTimeRepository.addListener(notifyListenersCall);
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

  @override
  void dispose() {
    super.dispose();
    _pointInTimeRepository.removeListener(notifyListenersCall);
  }
}
