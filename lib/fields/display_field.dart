import 'package:ceal_chronicler_f/utils/json_serializable.dart';

abstract class DisplayField<T> extends JsonSerializable{
  String fieldName;
  T value;

  DisplayField(this.fieldName, this.value);

  String getDisplayValue();

  void setValueFromString(String inputValue);
}