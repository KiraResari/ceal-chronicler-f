import '../fields/string_display_field.dart';

class WeaponField extends StringDisplayField {
  static const staticFieldName = "Weapon: ";
  static const defaultValue = "No Weapon";

  WeaponField([String? value]) : super(staticFieldName, value ?? defaultValue);

  WeaponField.fromJsonString(String jsonString)
      : super.fromJsonString(jsonString);

  WeaponField.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
