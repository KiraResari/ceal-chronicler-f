import 'package:ceal_chronicler_f/fields/display_field.dart';

class CharacterName extends DisplayField{

  String name;

  CharacterName(super.fieldName, this.name);

  @override
  String getDisplayValue() {
    return name;
  }

}