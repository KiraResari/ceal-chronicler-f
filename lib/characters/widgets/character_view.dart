import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../key_fields/location_id_key_field.dart';
import '../../locations/widgets/location_id_key_field_view.dart';
import '../../utils/widgets/temporal_entity_view.dart';
import '../model/character.dart';
import 'character_view_controller.dart';

class CharacterView
    extends TemporalEntityView<Character, CharacterViewController> {
  const CharacterView({super.key, required Character character})
      : super(entity: character);

  @override
  CharacterViewController createController() {
    return CharacterViewController(entity);
  }

  @override
  List<TableRow> buildAdditionalEntityTableChildren(BuildContext context) {
    LocationIdKeyField locationIdKeyField =
        context.watch<CharacterViewController>().locationIdKeyField;
    return [
      buildTableRow(context, "Present Location",
          LocationIdKeyFieldView(locationIdKeyField))
    ];
  }
}
