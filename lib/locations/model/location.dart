import 'dart:convert';

import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'location_id.dart';
import 'location_level.dart';

class Location extends TemporalEntity<LocationId> {
  static const defaultName = "New Location";
  static const String _parentLocationKey = "parentLocation";
  static const String _locationLevelKey = "locationLevel";

  LocationId? parentLocation;
  LocationLevel locationLevel;

  Location(PointInTimeId firstAppearance)
      : locationLevel = LocationLevel.notSet,
        super(defaultName, LocationId(), firstAppearance);

  Location.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Location.fromJson(Map<String, dynamic> json)
      : parentLocation = _buildLocationId(json),
        locationLevel = _buildLocationLevel(json),
        super.fromJson(json, LocationId.fromString(json[IdHolder.idKey]));

  static LocationId? _buildLocationId(Map<String, dynamic> json) {
    var parentLocationMap = json[_parentLocationKey];
    return parentLocationMap == null
        ? null
        : LocationId.fromJson(parentLocationMap);
  }

  static LocationLevel _buildLocationLevel(Map<String, dynamic> json) {
    var levelString = json[_locationLevelKey];
    return LocationLevel.fromJson(levelString);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = super.toJson();
    jsonMap[_parentLocationKey] = parentLocation?.toJson();
    jsonMap[_locationLevelKey] = locationLevel.name;
    return jsonMap;
  }

  @override
  String toString() => 'Location{id: $id}';
}
