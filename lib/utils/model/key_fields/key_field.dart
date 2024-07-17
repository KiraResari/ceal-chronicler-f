import 'package:ceal_chronicler_f/utils/map_utils.dart';

import '../../../io/json_serializable.dart';
import '../../../timeline/model/point_in_time_id.dart';

abstract class KeyField<T> extends JsonSerializable{
  static const String initialValueKey = "initialValue";
  static const String keysKey = "keys";


  final T initialValue;
  final Map<PointInTimeId, T> keys;

  KeyField(this.initialValue) : keys = {};

  KeyField.fromDecodedJson(this.initialValue, this.keys);

  @override
  Map<String, dynamic> toJson() => {
    initialValueKey: initialValueToJson(initialValue),
    keysKey: keysToJson(keys),
  };

  String initialValueToJson(T initialValue);

  Map<String, dynamic> keysToJson(Map<PointInTimeId, T> keys);

  void addOrUpdateKeyAtTime(T newValue, PointInTimeId pointInTimeId) {
    keys[pointInTimeId] = newValue;
  }

  void deleteKeyAtTime(PointInTimeId pointInTimeId) {
    keys.remove(pointInTimeId);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is KeyField &&
              runtimeType == other.runtimeType &&
              initialValue == other.initialValue &&
              MapUtils.areEqual(keys, other.keys);

  @override
  int get hashCode => initialValue.hashCode ^ keys.hashCode;

  @override
  String toString() {
    return 'KeyField{initialValue: $initialValue, keys: $keys}';
  }
}