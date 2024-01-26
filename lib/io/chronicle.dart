import 'dart:convert';

import '../timeline/point_in_time.dart';
import '../utils/list_comparer.dart';
import 'json_serializable.dart';

class Chronicle extends JsonSerializable {
  static const String pointsInTimeKey = "pointsInTime";

  final List<PointInTime> pointsInTime;

  Chronicle({required this.pointsInTime});

  Chronicle.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Chronicle.fromJson(Map<String, dynamic> json)
      : pointsInTime = _buildPointsInTimeFromJson(json[pointsInTimeKey]);

  static List<PointInTime> _buildPointsInTimeFromJson(
      List<dynamic> jsonEntries) {
    return jsonEntries.map((e) => PointInTime.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() => {
        pointsInTimeKey: pointsInTime,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chronicle &&
          runtimeType == other.runtimeType &&
          ListComparer.containEqualElementsInSameOrder(
              pointsInTime, other.pointsInTime);

  @override
  int get hashCode => pointsInTime.hashCode;

  @override
  String toString() {
    return 'Chronicle{pointsInTime: $pointsInTime}';
  }
}
