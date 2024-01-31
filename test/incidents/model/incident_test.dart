import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Incident to JSON and back should return equal object",
    () {
      var originalIncident = Incident("Test");

      String jsonString = originalIncident.toJsonString();
      var decodedIncident = Incident.fromJsonString(jsonString);

      expect(decodedIncident, equals(originalIncident));
    },
  );
}
