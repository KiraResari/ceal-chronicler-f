import '../fields/string_display_field.dart';

class SpeciesField extends StringDisplayField{

  static const staticFieldName = "Species";

  SpeciesField(String value) : super(staticFieldName, value);
}