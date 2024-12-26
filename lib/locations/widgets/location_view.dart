import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../characters/model/character.dart';
import '../../characters/widgets/character_button.dart';
import '../../utils/string_key.dart';
import '../../utils/widgets/temporal_entity_view.dart';
import '../model/location.dart';
import 'edit_parent_location_button.dart';
import 'location_button.dart';
import 'location_view_controller.dart';

class LocationView
    extends TemporalEntityView<Location, LocationViewController> {
  LocationView({required Location location})
      : super(entity: location, key: StringKey(location.toString()));

  @override
  LocationViewController createController() {
    return LocationViewController(entity);
  }

  @override
  List<TableRow> buildAdditionalEntityTableChildren(BuildContext context) {
    return [
      buildTableRow(
          context, "Characters present", _buildCharactersPresent(context)),
      buildTableRow(context, "Parent location", _buildParentLocation(context)),
      buildTableRow(context, "Child Locations", _buildChildLocations(context)),
    ];
  }

  Widget _buildCharactersPresent(BuildContext context) {
    List<Character> charactersPresent =
        context.watch<LocationViewController>().charactersPresentAtLocation;
    if (charactersPresent.isEmpty) {
      return const Text("none");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: charactersPresent
          .map((character) => CharacterButton(character))
          .toList(),
    );
  }

  Widget _buildParentLocation(BuildContext context) {
    Location? parentLocation =
        context.watch<LocationViewController>().parentLocation;
    return Row(
      children: [
        parentLocation == null
            ? const Text("none")
            : LocationButton(parentLocation),
        EditParentLocationButton(entity, parentLocation),
      ],
    );
  }

  Widget _buildChildLocations(BuildContext context) {
    List<Location> childLocations =
        context.watch<LocationViewController>().childLocations;
    if (childLocations.isEmpty) {
      return const Text("none");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          childLocations.map((location) => LocationButton(location)).toList(),
    );
  }
}
