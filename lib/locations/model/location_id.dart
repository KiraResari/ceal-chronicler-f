import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class LocationId extends ReadableUuid {
  LocationId() : super();

  LocationId.fromString(String uuid) : super.fromString(uuid);

  LocationId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
