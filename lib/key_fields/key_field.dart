import 'package:ceal_chronicler_f/utils/map_utils.dart';

import '../../../io/json_serializable.dart';
import '../../../timeline/model/point_in_time_id.dart';
import '../exceptions/invalid_operation_exception.dart';

abstract class KeyField<T> extends JsonSerializable {
  static const String initialValueKey = "initialValue";
  static const String keysKey = "keys";

  final T? initialValue;
  final Map<PointInTimeId, T> keys;

  KeyField({this.initialValue}) : keys = {};

  KeyField.fromDecodedJson(this.initialValue, this.keys);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {keysKey: keysToJson(keys)};
    if (initialValue != null) {
      jsonMap[initialValueKey] = initialValueToJson(initialValue);
    }
    return jsonMap;
  }

  String initialValueToJson(T? initialValue);

  Map<String, dynamic> keysToJson(Map<PointInTimeId, T> keys);

  void addOrUpdateKeyAtTime(T newValue, PointInTimeId pointInTimeId) {
    keys[pointInTimeId] = newValue;
  }

  void deleteKeyAtTime(PointInTimeId pointInTimeId) {
    if (keys[pointInTimeId] == null) {
      throw InvalidOperationException(
          "KeyField does not contain entry for PointInTime $pointInTimeId");
    }
    keys.remove(pointInTimeId);
  }

  bool hasKeyAt(PointInTimeId id) => keys.containsKey(id);

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
