import '../fields/string_display_field.dart';

class CharacterNameField extends StringDisplayField {
  static const staticFieldName = "Name: ";
  static const defaultValue = "Unnamed Character";

  CharacterNameField([String? value])
      : super(staticFieldName, value ?? defaultValue);

  CharacterNameField.fromJsonString(String jsonString)
      : super.fromJsonString(jsonString);

  CharacterNameField.fromJson(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap);
}
