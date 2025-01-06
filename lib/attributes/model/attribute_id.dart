import '../../utils/readable_uuid.dart';

class AttributeId extends ReadableUuid {
  AttributeId() : super();

  AttributeId.fromString(String uuid) : super.fromString(uuid);

  AttributeId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
