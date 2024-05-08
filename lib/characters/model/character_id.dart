import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class CharacterId extends ReadableUuid {
  CharacterId() : super();

  CharacterId.fromString(String uuid) : super.fromString(uuid);

  CharacterId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
