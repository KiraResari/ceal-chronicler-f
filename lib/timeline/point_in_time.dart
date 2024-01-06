import '../utils/readable_uuid.dart';

class PointInTime{
  final ReadableUuid id = ReadableUuid();
  String name;

  PointInTime(this.name);
}