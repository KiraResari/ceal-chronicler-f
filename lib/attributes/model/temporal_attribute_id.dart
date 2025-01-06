import '../../utils/readable_uuid.dart';

class TemporalAttributeId extends ReadableUuid {
  TemporalAttributeId() : super();

  TemporalAttributeId.fromString(String uuid) : super.fromString(uuid);

  TemporalAttributeId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
