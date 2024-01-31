import 'package:ceal_chronicler_f/incidents/model/incident_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Point in Time to JSON and back should return equal object",
    () {
      var originalPoint = PointInTime("Test");

      String jsonString = originalPoint.toJsonString();
      var decodedPoint = PointInTime.fromJsonString(jsonString);

      expect(decodedPoint, equals(originalPoint));
    },
  );

  test(
    "Adding incident reference should work",
    () {
      var point = PointInTime("Test Point");
      var incidentReference = IncidentId();

      point.addIncidentReference(incidentReference);

      expect(point.incidentReferences.length, equals(1));
    },
  );

  test(
    "Parsing Point in Time to JSON and back should preserve incident references",
    () {
      var originalPoint = PointInTime("Test Point");
      var incidentReference = IncidentId();
      originalPoint.addIncidentReference(incidentReference);

      String jsonString = originalPoint.toJsonString();
      var decodedPoint = PointInTime.fromJsonString(jsonString);

      expect(decodedPoint.incidentReferences, contains(incidentReference));
    },
  );

  test(
    "Points in time should be equal even if incident references differ",
        () {
      var originalPoint = PointInTime("Test Point");
      var incidentReference = IncidentId();

      String jsonString = originalPoint.toJsonString();
      var decodedPoint = PointInTime.fromJsonString(jsonString);
      decodedPoint.addIncidentReference(incidentReference);

      expect(originalPoint, equals(decodedPoint));
    },
  );

  test(
    "Points in time should be equal even if name differs",
        () {
      var originalPoint = PointInTime("Test Point");

      String jsonString = originalPoint.toJsonString();
      var decodedPoint = PointInTime.fromJsonString(jsonString);
      decodedPoint.name = "Renamed Point";

      expect(originalPoint, equals(decodedPoint));
    },
  );
}
