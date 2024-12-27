import 'package:flutter/material.dart';

import '../../../utils/widgets/buttons/dropdown_popup_button.dart';
import '../../model/location.dart';
import '../../model/location_connection_direction.dart';
import '../../model/location_id.dart';
import 'add_location_connection_button_controller.dart';

class AddLocationConnectionButton extends DropdownPopupButton<LocationId> {
  AddLocationConnectionButton(
      Location locationBeingEdited, LocationConnectionDirection direction,
      {super.key})
      : super(
          controller: AddLocationConnectionButtonController(
              locationBeingEdited, direction),
          initialSelection: locationBeingEdited.parentLocation,
          labelText: "Connect location to the ${direction.name}",
          icon: Icons.link,
        );
}
