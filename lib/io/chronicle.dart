import 'dart:convert';

import 'package:ceal_chronicler_f/parties/model/party.dart';

import '../characters/model/character.dart';
import '../incidents/model/incident.dart';
import '../locations/model/location.dart';
import '../locations/model/location_connection.dart';
import '../timeline/model/point_in_time.dart';
import '../utils/list_utils.dart';
import 'json_serializable.dart';

class Chronicle extends JsonSerializable {
  static const String pointsInTimeKey = "pointsInTime";
  static const String incidentsKey = "incidents";
  static const String charactersKey = "characters";
  static const String locationsKey = "locations";
  static const String locationConnectionsKey = "locationConnections";
  static const String partiesKey = "parties";

  final List<PointInTime> pointsInTime;
  final List<Incident> incidents;
  final List<Character> characters;
  final List<Location> locations;
  final List<LocationConnection> locationConnections;
  final List<Party> parties;

  Chronicle({
    required this.pointsInTime,
    required this.incidents,
    required this.characters,
    required this.locations,
    required this.locationConnections,
    required this.parties,
  });

  Chronicle.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Chronicle.fromJson(Map<String, dynamic> json)
      : pointsInTime =
            _extractList(json, pointsInTimeKey, (e) => PointInTime.fromJson(e)),
        incidents =
            _extractList(json, incidentsKey, (e) => Incident.fromJson(e)),
        characters =
            _extractList(json, charactersKey, (e) => Character.fromJson(e)),
        locations =
            _extractList(json, locationsKey, (e) => Location.fromJson(e)),
        locationConnections = _extractList(json, locationConnectionsKey,
            (e) => LocationConnection.fromJson(e)),
        parties = _extractList(json, partiesKey, (e) => Party.fromJson(e));

  static List<T> _extractList<T>(
      Map<String, dynamic> json, String key, T Function(dynamic) fromJson) {
    return json.containsKey(key)
        ? (json[key] as List).map(fromJson).toList().cast<T>()
        : [];
  }

  @override
  Map<String, dynamic> toJson() => {
        pointsInTimeKey: pointsInTime,
        incidentsKey: incidents,
        charactersKey: characters,
        locationsKey: locations,
        locationConnectionsKey: locationConnections,
        partiesKey: parties,
      };

  @override
  String toString() {
    return 'Chronicle{pointsInTime: $pointsInTime, incidents: $incidents, characters: $characters, locations: $locations, locationConnections: $locationConnections}, parties: $parties';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chronicle &&
          runtimeType == other.runtimeType &&
          ListUtils.containEqualElementsInSameOrder(
              pointsInTime, other.pointsInTime) &&
          ListUtils.containEqualElementsInSameOrder(
              incidents, other.incidents) &&
          ListUtils.containEqualElementsInSameOrder(
              characters, other.characters) &&
          ListUtils.containEqualElementsInSameOrder(
              locations, other.locations) &&
          ListUtils.containEqualElementsInSameOrder(
              locationConnections, other.locationConnections) &&
          ListUtils.containEqualElementsInSameOrder(
              parties, other.parties);

  @override
  int get hashCode =>
      pointsInTime.hashCode ^
      incidents.hashCode ^
      characters.hashCode ^
      locations.hashCode ^
      locationConnections.hashCode ^
      parties.hashCode;
}
