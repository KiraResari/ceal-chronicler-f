import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late IncidentRepository repository;
  setUp(() {
    repository = IncidentRepository();
  });

  test("Newly created repository should be empty", () {
    expect(repository.incidents.length, equals(0));
  });

  test("Adding new incident should work", () {
    var incident = Incident();
    repository.add(incident);

    expect(repository.incidents.length, equals(1));
  });

  test("Removing incident should work", () {
    var incident = Incident();
    repository.add(incident);
    var incidentToBeRemoved = repository.incidents.first;

    repository.remove(incidentToBeRemoved);

    expect(repository.incidents, isNot(contains(incidentToBeRemoved)));
  });
}
