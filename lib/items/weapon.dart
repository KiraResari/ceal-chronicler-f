import '../fields/string_display_field.dart';

class WeaponField extends StringDisplayField{

  static const staticFieldName = "Weapon";

  WeaponField(String value) : super(staticFieldName, value);
}