import 'package:ceal_chronicler_f/characters/widgets/character_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../characters/model/character.dart';
import '../../utils/widgets/temporal_entity_view.dart';
import '../model/location.dart';
import 'location_view_controller.dart';

class LocationView
    extends TemporalEntityView<Location, LocationViewController> {
  const LocationView({super.key, required Location location})
      : super(entity: location);

  @override
  LocationViewController createController() {
    return LocationViewController(entity);
  }

  @override
  List<TableRow> buildAdditionalEntityTableChildren(BuildContext context) {
    return [
      buildTableRow(
          context, "Characters present", _buildCharactersPresent(context))
    ];
  }

  Widget _buildCharactersPresent(BuildContext context) {
    List<Character> charactersPresent =
        context.watch<LocationViewController>().charactersPresentAtLocation;
    return Column(
      children: charactersPresent
          .map((character) => CharacterButton(character))
          .toList(),
    );
  }
}
