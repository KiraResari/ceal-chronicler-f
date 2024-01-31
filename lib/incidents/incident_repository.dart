import '../exceptions/invalid_operation_exception.dart';
import 'incident.dart';

class IncidentRepository {
  static const defaultName = "New incident";

  List<Incident> incidents = [];

  void createNew() {
    var incident = Incident(defaultName);
    incidents.add(incident);
  }

  void remove(Incident incidentToBeRemoved) {
    _assertExistsInRepository(incidentToBeRemoved);
    incidents.remove(incidentToBeRemoved);
  }

  void _assertExistsInRepository(Incident incident) {
    if (!incidents.contains(incident)) {
      throw InvalidOperationException(
          "IncidentRepository does not contain Incident with name ${incident.name}");
    }
  }
}
