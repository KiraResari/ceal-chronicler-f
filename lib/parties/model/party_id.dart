import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class PartyId extends ReadableUuid {
  PartyId() : super();

  PartyId.fromString(String uuid) : super.fromString(uuid);

  PartyId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
