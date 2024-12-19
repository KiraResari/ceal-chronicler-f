import 'dart:convert';

import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'location_id.dart';

class Location extends TemporalEntity<LocationId> {
  static const defaultName = "New Location";

  Location(PointInTimeId firstAppearance)
      : super(defaultName, LocationId(), firstAppearance);

  Location.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Location.fromJson(Map<String, dynamic> json)
      : super.fromJson(json, LocationId.fromString(json[IdHolder.idKey]));

  @override
  String toString() =>
      'Location{id: $id, name: $name, firstAppearance: $firstAppearance, lastAppearance: $lastAppearance}';
}
