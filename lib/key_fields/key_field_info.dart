import '../timeline/model/point_in_time_id.dart';

class KeyFieldInfo<T> {
  final String fieldName;
  final PointInTimeId key;
  final T value;

  KeyFieldInfo(this.fieldName, this.key, this.value);
}
