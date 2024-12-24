import 'dart:convert';

import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'location_id.dart';

class Location extends TemporalEntity<LocationId> {
  static const defaultName = "New Location";
  static const String _parentLocationKey = "parentLocation";

  LocationId? parentLocation;

  Location(PointInTimeId firstAppearance)
      : super(defaultName, LocationId(), firstAppearance);

  Location.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Location.fromJson(Map<String, dynamic> json)
      : parentLocation = _buildLocationId(json),
        super.fromJson(json, LocationId.fromString(json[IdHolder.idKey]));

  static LocationId? _buildLocationId(Map<String, dynamic> json) {
    var parentLocationMap = json[_parentLocationKey];
    return parentLocationMap == null
        ? null
        : LocationId.fromJson(parentLocationMap);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = super.toJson();
    jsonMap[_parentLocationKey] = parentLocation;
    return jsonMap;
  }

  @override
  String toString() => 'Location{id: $id}';
}
