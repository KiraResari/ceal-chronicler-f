import 'dart:convert';

import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'party_id.dart';

class Party extends TemporalEntity<PartyId> {
  static const defaultName = "New Party";

  Party(PointInTimeId firstAppearance)
      : super(defaultName, PartyId(), firstAppearance);

  Party.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Party.fromJson(Map<String, dynamic> json)
      : super.fromJson(json, PartyId.fromString(json[IdHolder.idKey]));

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = super.toJson();
    return jsonMap;
  }

  @override
  String toString() => 'Party{id: $id}';
}
