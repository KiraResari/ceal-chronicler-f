import '../../exceptions/invalid_operation_exception.dart';
import 'incident.dart';
import 'incident_id.dart';

class IncidentRepository {
  Map<IncidentId, Incident> _incidents = {};

  List<Incident> get incidents => _incidents.values.toList();

  set incidents(List<Incident> incidents) {
    _incidents = {};
    for (Incident incident in incidents) {
      add(incident);
    }
  }

  void add(Incident incident) {
    _incidents[incident.id] = incident;
  }

  void remove(Incident incidentToBeRemoved) {
    _assertExistsInRepository(incidentToBeRemoved);
    _incidents.remove(incidentToBeRemoved.id);
  }

  void _assertExistsInRepository(Incident incident) {
    if (!incidents.contains(incident)) {
      throw InvalidOperationException(
          "IncidentRepository does not contain Incident with name ${incident.name}");
    }
  }

  List<Incident> getIncidentsByReference(List<IncidentId> incidentReferences) {
    List<Incident> incidents = [];
    for (IncidentId incidentReference in incidentReferences) {
      Incident? incident = _incidents[incidentReference];
      if (incident != null) {
        incidents.add(incident);
      }
    }
    return incidents;
  }
}
