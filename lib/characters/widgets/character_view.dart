import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return [
      buildTableRow(
          context, "Present Location", _buildPresentLocationDropdown(context))
    ];
  }

  Widget _buildPresentLocationDropdown(BuildContext context) {
    var controller = context.read<CharacterViewController>();
    LocationId presentLocation =
        context.watch<CharacterViewController>().presentLocation;
    List<DropdownMenuEntry<LocationId>> entries =
        context.watch<CharacterViewController>().getValidLocationEntries;

    return DropdownMenu<LocationId>(
      initialSelection: presentLocation,
      dropdownMenuEntries: entries,
      onSelected: (LocationId? locationId) {
        controller.updatePresentLocation(locationId);
      },
    );
  }
}
