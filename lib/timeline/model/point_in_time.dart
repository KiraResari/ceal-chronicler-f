import 'dart:convert';

import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';

import '../../io/json_serializable.dart';

class PointInTime extends JsonSerializable {
  static const String idKey = "id";
  static const String nameKey = "name";
  static const String incidentReferencesKey = "incidentReferences";

  final PointInTimeId id;
  String name;
  List<IncidentId> incidentReferences = [];

  PointInTime(this.name) : id = PointInTimeId();

  PointInTime.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  PointInTime.fromJson(Map<String, dynamic> json)
      : id = PointInTimeId.fromString(json[idKey]),
        name = json[nameKey],
        incidentReferences =
            _buildIncidentReferencesTimeFromJson(json[incidentReferencesKey]);

  static List<IncidentId> _buildIncidentReferencesTimeFromJson(
      List<dynamic> jsonEntries) {
    return jsonEntries.map((e) => IncidentId.fromJson(e)).toList();
  }

  void addIncidentReference(IncidentId incidentReference) {
    incidentReferences.add(incidentReference);
  }

  void removeIncidentReference(IncidentId incidentReference) {
    if (incidentReferences.contains(incidentReference)) {
      incidentReferences.remove(incidentReference);
    } else {
      throw InvalidOperationException(
          "Can't remove Incident Reference from point in time because this point in time does not contain the incident reference\n"
          "Point: $this\n"
          "Incident Reference: $incidentReference");
    }
  }

  @override
  String toString() {
    return 'PointInTime{id: $id, name: $name, incidentReferences: $incidentReferences}';
  }

  @override
  Map<String, dynamic> toJson() => {
        idKey: id.uuid,
        nameKey: name,
        incidentReferencesKey: incidentReferences,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointInTime &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
