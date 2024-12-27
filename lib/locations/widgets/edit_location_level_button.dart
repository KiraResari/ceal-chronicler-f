import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import '../../utils/widgets/dialogs/select_dropdown_dialog.dart';
import '../model/location.dart';
import '../model/location_level.dart';
import 'edit_location_level_button_controller.dart';

class EditLocationLevelButton extends SmallCircularButton {
  final Location locationBeingEdited;
  final EditLocationLevelButtonController controller;

  EditLocationLevelButton(this.locationBeingEdited, {super.key})
      : controller = EditLocationLevelButtonController(locationBeingEdited),
        super(icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    LocationLevel? selectedValue = await _showSelectionDialog(context);
    controller.update(selectedValue);
  }

  Future<LocationLevel?> _showSelectionDialog(BuildContext context) {
    List<DropdownMenuEntry<LocationLevel>> validEntries =
        controller.validMenuEntries;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectDropdownDialog<LocationLevel>(
          initialSelection: locationBeingEdited.locationLevel,
          entries: validEntries,
          labelText: "Select location level",
        );
      },
    );
  }
}