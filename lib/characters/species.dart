import 'package:ceal_chronicler_f/fields/display_field.dart';

class Species extends DisplayField{

  String name;

  Species(super.fieldName, this.name);

  @override
  String getDisplayValue() {
    return name;
  }

}