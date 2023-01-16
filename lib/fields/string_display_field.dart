import 'package:ceal_chronicler_f/fields/display_field.dart';

abstract class StringDisplayField extends DisplayField<String>{
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
}