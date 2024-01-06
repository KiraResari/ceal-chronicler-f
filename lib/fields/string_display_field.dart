import 'package:ceal_chronicler_f/exceptions/serialization_exception.dart';
import 'package:ceal_chronicler_f/fields/display_field.dart';

abstract class StringDisplayField extends DisplayField<String> {
  StringDisplayField(super.fieldName, super.value);

  StringDisplayField.fromJsonString(String jsonString)
      : super.fromJsonString(jsonString);

  StringDisplayField.fromJson(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap);

  @override
  String getDisplayValue() {
    return value;
  }

  @override
  String toString() {
    return getDisplayValue();
  }

  @override
  void setValueFromString(String inputValue) {
    value = inputValue;
  }

  @override
  decodeValue(dynamic jsonValue) {
    if (jsonValue is String) {
      value = jsonValue;
    } else {
      throw SerializationException(
          "Error while trying to decode value of StringDisplayField: JSON value is not a string: $jsonValue");
    }
  }
}
