import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class IncidentId extends ReadableUuid {
  IncidentId() : super();

  IncidentId.fromString(String uuid) : super.fromString(uuid);
}
