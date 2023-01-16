import '../fields/string_display_field.dart';

class CharacterNameField extends StringDisplayField {
  static const staticFieldName = "Name";
  static const defaultValue = "Unnamed Character";

  CharacterNameField({String value = defaultValue})
      : super(staticFieldName, value);
}
