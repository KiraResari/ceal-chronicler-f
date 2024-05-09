import 'dart:convert';

import '../characters/model/character.dart';
import '../incidents/model/incident.dart';
import '../timeline/model/point_in_time.dart';
import '../utils/list_utils.dart';
import 'json_serializable.dart';

class Chronicle extends JsonSerializable {
  static const String pointsInTimeKey = "pointsInTime";
  static const String incidentsKey = "incidents";
  static const String charactersKey = "characters";

  final List<PointInTime> pointsInTime;
  final List<Incident> incidents;
  final List<Character> characters;

  Chronicle({
    required this.pointsInTime,
    required this.incidents,
    required this.characters,
  });

  Chronicle.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Chronicle.fromJson(Map<String, dynamic> json)
      : pointsInTime = _buildPointsInTimeFromJson(json),
        incidents = _buildIncidentsFromJson(json),
        characters = _buildCharactersFromJson(json);

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

  @override
  Map<String, dynamic> toJson() => {
        pointsInTimeKey: pointsInTime,
        incidentsKey: incidents,
        charactersKey: characters,
      };

  @override
  String toString() {
    return 'Chronicle{pointsInTime: $pointsInTime, incidents: $incidents, characters: $characters}';
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
              characters, other.characters);

  @override
  int get hashCode =>
      pointsInTime.hashCode ^ incidents.hashCode ^ characters.hashCode;
}
