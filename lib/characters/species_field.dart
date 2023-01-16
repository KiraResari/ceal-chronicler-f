import '../fields/string_display_field.dart';

class SpeciesField extends StringDisplayField{

  static const staticFieldName = "Species";
  static const defaultValue = "Unknown Species";

  SpeciesField({String value = defaultValue})
      : super(staticFieldName, value);
}