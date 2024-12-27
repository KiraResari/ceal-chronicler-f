import '../../utils/readable_uuid.dart';

class LocationConnectionId extends ReadableUuid {
  LocationConnectionId() : super();

  LocationConnectionId.fromString(String uuid) : super.fromString(uuid);

  LocationConnectionId.fromJson(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap);
}
