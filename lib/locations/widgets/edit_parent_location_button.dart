import 'package:flutter/material.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import '../../utils/widgets/dialogs/select_dropdown_dialog.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import 'edit_parent_location_button_controller.dart';

class EditParentLocationButton extends SmallCircularButton {
  final Location locationBeingEdited;
  final EditParentLocationButtonController controller;

  EditParentLocationButton(this.locationBeingEdited, {super.key})
      : controller = EditParentLocationButtonController(locationBeingEdited),
        super(icon: Icons.edit);

  @override
  void onPressed(BuildContext context) async {
    LocationId? selectedValue = await _showSelectionDialog(context);
    controller.updateParentLocation(locationBeingEdited, selectedValue);
  }

  Future<LocationId?> _showSelectionDialog(BuildContext context) {
    List<DropdownMenuEntry<LocationId>> validLocations =
        controller.validLocations;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectDropdownDialog<LocationId>(
          initialSelection: locationBeingEdited.parentLocation,
          entries: validLocations,
          labelText: "Select parent location",
        );
      },
    );
  }
}
