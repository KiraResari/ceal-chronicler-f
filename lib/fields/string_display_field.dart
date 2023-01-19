import 'package:ceal_chronicler_f/fields/display_field.dart';

abstract class StringDisplayField extends DisplayField<String>{
  static const String _valueFieldName = "value";

  StringDisplayField(super.fieldName, super.value);

  @override
  String getDisplayValue(){
    return value;
  }

  @override
  String toString(){
    return getDisplayValue();
  }

  @override
  void setValueFromString(String inputValue){
      value = inputValue;
  }
  @override
  Map<String, dynamic> toJson() => {
    _valueFieldName: value,
  };
}