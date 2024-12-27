import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../characters/model/character.dart';
import '../../../characters/widgets/character_button.dart';
import '../../../utils/string_key.dart';
import '../../../utils/widgets/buttons/delete_button.dart';
import '../../../utils/widgets/temporal_entity_view.dart';
import '../../model/location.dart';
import '../../model/location_connection_direction.dart';
import '../../model/location_level.dart';
import '../buttons/add_location_connection_button.dart';
import '../buttons/delete_location_connection_button.dart';
import '../buttons/edit_location_level_button.dart';
import '../buttons/edit_parent_location_button.dart';
import '../buttons/location_button.dart';
import '../panels/connected_location_panel_template.dart';
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

  @override
  List<Widget> buildAdditionalColumns(BuildContext context) {
    return ([_buildLinkedLocationsColumn(context)]);
  }

  Widget _buildLinkedLocationsColumn(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.titleSmall!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLevelParentAndChildLocationBlock(context),
        Text("Adjacent Locations", style: style),
        _buildAdjacentLocationsBlock(context),
      ],
    );
  }

  Widget _buildLevelParentAndChildLocationBlock(BuildContext context) {
    List<TableRow> children = [
      buildTableRow(context, "Location level", _buildLocationLevel(context)),
      buildTableRow(
          context, "Parent location", _buildParentLocationPanel(context)),
      buildTableRow(context, "Child Locations", _buildChildLocations(context)),
    ];
    return buildEntityTable(context, children);
  }

  Widget _buildLocationLevel(BuildContext context) {
    LocationLevel locationLevel =
        context.watch<LocationViewController>().locationLevel;
    return Row(
      children: [
        Text(locationLevel.iconAndName),
        EditLocationLevelButton(entity),
      ],
    );
  }

  Widget _buildParentLocationPanel(BuildContext context) {
    Location? parentLocation =
        context.watch<LocationViewController>().parentLocation;
    var children = [
      parentLocation == null
          ? const Text("none")
          : LocationButton(parentLocation),
      EditParentLocationButton(entity),
    ];
    if (parentLocation != null) {
      children.add(DeleteButton(
        onPressedFunction: () => _onDeleteParentLocationPressed(context),
        tooltip: "Delete parent location",
      ));
    }
    return Row(
      children: children,
    );
  }

  void _onDeleteParentLocationPressed(BuildContext context) {
    var controller = context.read<LocationViewController>();
    controller.deleteParentLocation();
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

  Widget _buildAdjacentLocationsBlock(BuildContext context) {
    String name = context.watch<LocationViewController>().name;
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.northwest),
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.north),
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.northeast),
        ]),
        TableRow(children: [
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.west),
          Text(name),
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.east),
        ]),
        TableRow(children: [
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.southwest),
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.south),
          _buildAdjacentLocationBlock(
              context, LocationConnectionDirection.southeast),
        ]),
      ],
    );
  }

  Widget _buildAdjacentLocationBlock(
    BuildContext context,
    LocationConnectionDirection direction,
  ) {
    List<Widget> connectedLocationPanels =
        _buildConnectedLocationPanels(context, direction);
    return Column(
      children: [
        ...connectedLocationPanels,
        AddLocationConnectionButton(entity, direction),
      ],
    );
  }

  List<Widget> _buildConnectedLocationPanels(
    BuildContext context,
    LocationConnectionDirection direction,
  ) {
    List<ConnectedLocationPanelTemplate> connectedLocations = context
        .watch<LocationViewController>()
        .getConnectedLocationsForDirection(direction);
    List<Widget> connectedLocationPanels = connectedLocations
        .map((connectedLocation) =>
            _buildConnectedLocationPanel(connectedLocation))
        .toList();
    return connectedLocationPanels;
  }

  Widget _buildConnectedLocationPanel(
    ConnectedLocationPanelTemplate connectedLocation,
  ) {
    return Row(
      children: [
        LocationButton(connectedLocation.location),
        DeleteLocationConnectionButton(connectedLocation.locationConnection),
      ],
    );
  }
}
