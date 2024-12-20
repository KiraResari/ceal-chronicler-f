import 'package:ceal_chronicler_f/key_fields/location_id_key_field.dart';

import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/character.dart';

class CharacterViewController extends TemporalEntityViewController<Character> {
  CharacterViewController(Character character) : super(character);

  LocationIdKeyField get locationIdKeyField => entity.presentLocation;
}
