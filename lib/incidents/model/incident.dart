import 'dart:convert';

import '../../utils/model/id_holder.dart';
import 'incident_id.dart';

class Incident extends IdHolder<IncidentId> {
  static const String nameKey = "name";
  static const defaultName = "New incident";

  String name = defaultName;

  Incident() : super(IncidentId());

  Incident.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Incident.fromJson(Map<String, dynamic> json)
      : name = json[nameKey],
        super(IncidentId.fromString(json[IdHolder.idKey]));

  String get identifier => name;

  String get identifierDescription => nameKey;

  @override
  String toString() => 'Incident{id: $id, name: $name}';

  @override
  Map<String, dynamic> toJson() => {
        IdHolder.idKey: id.uuid,
        nameKey: name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Incident && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}
