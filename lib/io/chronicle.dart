import 'dart:convert';

import '../characters/model/character.dart';
import '../incidents/model/incident.dart';
import '../locations/model/location.dart';
import '../timeline/model/point_in_time.dart';
import '../utils/list_utils.dart';
import 'json_serializable.dart';

class Chronicle extends JsonSerializable {
  static const String pointsInTimeKey = "pointsInTime";
  static const String incidentsKey = "incidents";
  static const String charactersKey = "characters";
  static const String locationsKey = "locations";

  final List<PointInTime> pointsInTime;
  final List<Incident> incidents;
  final List<Character> characters;
  final List<Location> locations;

  Chronicle({
    required this.pointsInTime,
    required this.incidents,
    required this.characters,
    required this.locations,
  });

  Chronicle.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Chronicle.fromJson(Map<String, dynamic> json)
      : pointsInTime = _buildPointsInTimeFromJson(json),
        incidents = _buildIncidentsFromJson(json),
        characters = _buildCharactersFromJson(json),
        locations = _buildLocationsFromJson(json);

  static List<PointInTime> _buildPointsInTimeFromJson(
      Map<String, dynamic> json) {
    if (json.containsKey(pointsInTimeKey)) {
      List<dynamic> jsonEntries = json[pointsInTimeKey];
      return jsonEntries.map((e) => PointInTime.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static List<Incident> _buildIncidentsFromJson(Map<String, dynamic> json) {
    if (json.containsKey(incidentsKey)) {
      List<dynamic> jsonEntries = json[incidentsKey];
      return jsonEntries.map((e) => Incident.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static List<Character> _buildCharactersFromJson(Map<String, dynamic> json) {
    if (json.containsKey(charactersKey)) {
      List<dynamic> jsonEntries = json[charactersKey];
      return jsonEntries.map((e) => Character.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static List<Location> _buildLocationsFromJson(Map<String, dynamic> json) {
    if (json.containsKey(locationsKey)) {
      List<dynamic> jsonEntries = json[locationsKey];
      return jsonEntries.map((e) => Location.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        pointsInTimeKey: pointsInTime,
        incidentsKey: incidents,
        charactersKey: characters,
        locationsKey: locations,
      };

  @override
  String toString() {
    return 'Chronicle{pointsInTime: $pointsInTime, incidents: $incidents, characters: $characters, locations: $locations}';
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
          ListUtils.containEqualElementsInSameOrder(locations, other.locations);

  @override
  int get hashCode =>
      pointsInTime.hashCode ^
      incidents.hashCode ^
      characters.hashCode ^
      locations.hashCode;
}
