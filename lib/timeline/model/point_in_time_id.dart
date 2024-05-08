import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class PointInTimeId extends ReadableUuid {
  PointInTimeId() : super();

  PointInTimeId.fromString(String uuid) : super.fromString(uuid);

  PointInTimeId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
