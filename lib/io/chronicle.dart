import 'dart:convert';

import '../incidents/model/incident.dart';
import '../timeline/model/point_in_time.dart';
import '../utils/list_utils.dart';
import 'json_serializable.dart';

class Chronicle extends JsonSerializable {
  static const String pointsInTimeKey = "pointsInTime";
  static const String incidentsKey = "incidents";

  final List<PointInTime> pointsInTime;
  final List<Incident> incidents;

  Chronicle({
    required this.pointsInTime,
    required this.incidents,
  });

  Chronicle.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Chronicle.fromJson(Map<String, dynamic> json)
      : pointsInTime = _buildPointsInTimeFromJson(json[pointsInTimeKey]),
        incidents = _buildIncidentsFromJson(json[incidentsKey]);

  static List<PointInTime> _buildPointsInTimeFromJson(
      List<dynamic> jsonEntries) {
    return jsonEntries.map((e) => PointInTime.fromJson(e)).toList();
  }

  static List<Incident> _buildIncidentsFromJson(List<dynamic> jsonEntries) {
    return jsonEntries.map((e) => Incident.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() => {
        pointsInTimeKey: pointsInTime,
        incidentsKey: incidents,
      };

  @override
  String toString() {
    return 'Chronicle{pointsInTime: $pointsInTime, incidents: $incidents}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chronicle &&
          runtimeType == other.runtimeType &&
          ListUtils.containEqualElementsInSameOrder(
              pointsInTime, other.pointsInTime) &&
          ListUtils.containEqualElementsInSameOrder(
              incidents, other.incidents);

  @override
  int get hashCode => pointsInTime.hashCode ^ incidents.hashCode;
}
