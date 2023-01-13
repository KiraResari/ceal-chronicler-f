import '../fields/string_display_field.dart';

class CharacterNameField extends StringDisplayField{

  static const staticFieldName = "Name";

  CharacterNameField(String value) : super(staticFieldName, value);
}