import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';

import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/incident.dart';
import '../model/incident_repository.dart';

class DeleteIncidentCommand extends Command {
  final _incidentRepository = getIt.get<IncidentRepository>();
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final Incident _incident;
  final List<PointInTime> _relatedPointsInTime = [];

  DeleteIncidentCommand(this._incident);

  @override
  void execute() {
    _incidentRepository.remove(_incident);
    _removeIncidentReferenceFromPointsInTime();
  }

  void _removeIncidentReferenceFromPointsInTime() {
    _relatedPointsInTime.clear();
    for (PointInTime point in _pointInTimeRepository.pointsInTime) {
      if (point.incidentReferences.contains(_incident.id)) {
        _relatedPointsInTime.add(point);
        point.removeIncidentReference(_incident.id);
      }
    }
  }

  @override
  String get executeMessage => "Removed incident '${_incident.name}'";

  @override
  void undo() {
    _incidentRepository.add(_incident);
    for (var point in _relatedPointsInTime) {
      point.addIncidentReference(_incident.id);
    }
  }

  @override
  String get undoMessage => "Restored deleted incident '${_incident.name}'";
}
