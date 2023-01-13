import '../fields/string_display_field.dart';

class WeaponField extends StringDisplayField {
  static const staticFieldName = "Weapon";
  static const defaultValue = "No Weapon";

  WeaponField({String value = defaultValue}) : super(staticFieldName, value);
}
