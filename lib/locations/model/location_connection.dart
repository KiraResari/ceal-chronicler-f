import 'dart:convert';

import '../../utils/model/id_holder.dart';
import 'location_connection_direction.dart';
import 'location_connection_id.dart';
import 'location_id.dart';

class LocationConnection extends IdHolder<LocationConnectionId> {
  static const String startLocationKey = "startLocation";
  static const String directionKey = "direction";
  static const String endLocationKey = "endLocation";

  final LocationId startLocation;
  final LocationConnectionDirection direction;
  final LocationId endLocation;

  LocationConnection(this.startLocation, this.direction, this.endLocation)
      : super(LocationConnectionId());

  LocationConnection.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  LocationConnection.fromJson(Map<String, dynamic> json)
      : startLocation = LocationId.fromString(json[startLocationKey]),
        direction = LocationConnectionDirection.fromName(json[directionKey]),
        endLocation = LocationId.fromString(json[endLocationKey]),
        super(LocationConnectionId.fromString(json[IdHolder.idKey]));

  @override
  String toString() => 'LocationConnectionId{id: $id}';

  @override
  Map<String, dynamic> toJson() => {
        IdHolder.idKey: id.uuid,
        startLocationKey: startLocation.uuid,
        directionKey: direction.name,
        endLocationKey: endLocation.uuid,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationConnection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startLocation == other.startLocation &&
          direction == other.direction &&
          endLocation == other.endLocation;

  @override
  int get hashCode =>
      id.hashCode ^
      startLocation.hashCode ^
      direction.hashCode ^
      endLocation.hashCode;
}
