import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/io/chronicle.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Chronicle to JSON and back should return equal object",
    () {
      Chronicle originalChronicle = _buildTestChronicle();

      String jsonString = originalChronicle.toJsonString();
      var decodedChronicle = Chronicle.fromJsonString(jsonString);

      expect(decodedChronicle, equals(originalChronicle));
    },
  );
}

Chronicle _buildTestChronicle() {
  var pointsInTime = [
    PointInTime("Test Point 1"),
    PointInTime("Test Point 2"),
  ];
  var incidents = [
    Incident(),
    Incident(),
  ];
  return Chronicle(
    pointsInTime: pointsInTime,
    incidents: incidents,
  );
}
