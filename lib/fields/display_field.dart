import 'package:ceal_chronicler_f/io/json_serializable_old.dart';

import '../exceptions/serialization_exception.dart';

abstract class DisplayField<T> extends JsonSerializableOld {
  static const String _fieldNameFieldName = "fieldName";
  static const String _valueFieldName = "value";

  late String fieldName;
  late T value;

  DisplayField(this.fieldName, this.value);

  DisplayField.fromJsonString(String jsonString)
      : super.fromJsonString(jsonString);

  DisplayField.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);

  String getDisplayValue();

  void setValueFromString(String inputValue);

  @override
  Map<String, dynamic> toJson() => {
        _fieldNameFieldName: fieldName,
        _valueFieldName: value,
      };

  @override
  decodeJson(Map<String, dynamic> jsonMap) {
    decodeFieldName(jsonMap[_fieldNameFieldName]);
    decodeValue(jsonMap[_valueFieldName]);
  }

  void decodeFieldName(dynamic jsonValue) {
    if (jsonValue is String) {
      fieldName = jsonValue;
    } else {
      throw SerializationException(
          "Error while trying to decode fieldName of DisplayField: JSON value is not a string: $jsonValue");
    }
  }

  decodeValue(dynamic jsonValue);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DisplayField) &&
          (other.runtimeType == runtimeType) &&
          (fieldName == other.fieldName) &&
          (value == other.value);

  @override
  int get hashCode => fieldName.hashCode + value.hashCode;
}
