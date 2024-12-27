import 'package:flutter/material.dart';

import '../../../utils/widgets/buttons/dropdown_popup_button.dart';
import '../../model/location.dart';
import '../../model/location_id.dart';
import 'edit_parent_location_button_controller.dart';

class EditParentLocationButton extends DropdownPopupButton<LocationId> {
  EditParentLocationButton(Location locationBeingEdited, {super.key})
      : super(
          controller: EditParentLocationButtonController(locationBeingEdited),
          initialSelection: locationBeingEdited.parentLocation,
          labelText: "Select parent location",
          icon: Icons.edit,
        );
}
