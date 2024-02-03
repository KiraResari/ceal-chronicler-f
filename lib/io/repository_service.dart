import 'package:ceal_chronicler_f/incidents/model/incident.dart';

import '../get_it_context.dart';
import '../incidents/model/incident_repository.dart';
import '../timeline/model/point_in_time.dart';
import '../timeline/model/point_in_time_repository.dart';
import 'chronicle.dart';

class RepositoryService {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _incidentRepository = getIt.get<IncidentRepository>();

  Chronicle assembleChronicle() {
    List<PointInTime> pointsInTime = _pointInTimeRepository.pointsInTime;
    List<Incident> incidents = _incidentRepository.incidents;
    return Chronicle(
      pointsInTime: pointsInTime,
      incidents: incidents,
    );
  }

  void distributeChronicle(Chronicle chronicle) {
    _pointInTimeRepository.pointsInTime = chronicle.pointsInTime;
    _incidentRepository.incidents = chronicle.incidents;
  }
}
