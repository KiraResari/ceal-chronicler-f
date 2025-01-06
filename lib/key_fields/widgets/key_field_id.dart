import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class KeyFieldId extends ReadableUuid {
  KeyFieldId() : super();

  KeyFieldId.fromString(String uuid) : super.fromString(uuid);

  KeyFieldId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
