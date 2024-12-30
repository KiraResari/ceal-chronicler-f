import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/io/chronicle.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_direction.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
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

  test(
    "Missing fields should not prevent loading",
    () {
      String jsonStringWithMissingFields =
          '{"pointsInTime":[{"id":"9bd32d25-ead5-452f-9f06-f31459c32c4a","name":"AD2101","incidentReferences":[{"uuid":"c2c7a458-ebda-450a-8d2c-673ba8f59733"}]}],"incidents":[{"id":"c2c7a458-ebda-450a-8d2c-673ba8f59733","name":"War was beginning"}]}';
      var decodedChronicle =
          Chronicle.fromJsonString(jsonStringWithMissingFields);

      expect(decodedChronicle.pointsInTime.first.name, equals("AD2101"));
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
  var characters = [
    Character(pointsInTime[0].id),
    Character(pointsInTime[1].id),
  ];
  var locations = [
    Location(pointsInTime[0].id),
    Location(pointsInTime[1].id),
  ];
  var locationConnections = [
    LocationConnection(
        locations[0].id, LocationConnectionDirection.west, locations[1].id)
  ];
  var parties = [
    Party(pointsInTime[0].id),
    Party(pointsInTime[1].id),
  ];
  return Chronicle(
    pointsInTime: pointsInTime,
    incidents: incidents,
    characters: characters,
    locations: locations,
    locationConnections: locationConnections,
    parties: parties,
  );
}
