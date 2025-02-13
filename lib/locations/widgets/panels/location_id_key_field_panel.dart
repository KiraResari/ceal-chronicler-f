import 'package:ceal_chronicler_f/locations/widgets/buttons/location_button.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../key_fields/location_id_key_field.dart';
import '../../../key_fields/widgets/next_key_button.dart';
import '../../../key_fields/widgets/previous_key_button.dart';
import '../../../key_fields/widgets/select_key_button.dart';
import '../../../key_fields/widgets/toggle_key_button.dart';
import '../../model/location.dart';
import '../../model/location_id.dart';
import 'location_id_key_field_panel_controller.dart';

class LocationIdKeyFieldPanel extends StatelessWidget {
  final LocationIdKeyField keyField;

  const LocationIdKeyFieldPanel(this.keyField, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationIdKeyFieldPanelController(keyField),
      builder: (context, child) => _buildView(context),
    );
  }

  Widget _buildView(BuildContext context) {
    return Row(
      children: [
        _buildPreviousKeyButton(context),
        _buildAddOrRemoveKeyButton(context),
        _buildNextKeyButton(context),
        _buildPresentLocationButton(context),
        _buildEditButton(context),
      ],
    );
  }

  Widget _buildPreviousKeyButton(BuildContext context) {
    var controller = context.read<LocationIdKeyFieldPanelController>();
    bool enabled = context.watch<LocationIdKeyFieldPanelController>().hasPrevious;
    return PreviousKeyButton(controller, enabled);
  }

  Widget _buildNextKeyButton(BuildContext context) {
    var controller = context.read<LocationIdKeyFieldPanelController>();
    bool enabled = context.watch<LocationIdKeyFieldPanelController>().hasNext;
    return NextKeyButton(controller, enabled);
  }

  Widget _buildAddOrRemoveKeyButton(BuildContext context) {
    var controller = context.read<LocationIdKeyFieldPanelController>();
    bool keyExistsAtCurrentPointInTime = context
        .watch<LocationIdKeyFieldPanelController>()
        .keyExistsAtCurrentPointInTime;
    return ToggleKeyButton(controller, keyExistsAtCurrentPointInTime);
  }

  Widget _buildPresentLocationButton(BuildContext context) {
    Location? presentLocation =
        context.watch<LocationIdKeyFieldPanelController>().presentLocation;
    if (presentLocation != null) {
      return LocationButton(presentLocation);
    }
    return const Text("Unknown");
  }

  Widget _buildEditButton(BuildContext context) {
    List<DropdownMenuEntry<LocationId>> entries =
        context.watch<LocationIdKeyFieldPanelController>().validLocationEntries;
    var controller = context.read<LocationIdKeyFieldPanelController>();
    return SelectKeyButton(
      controller: controller,
      entries: entries,
      labelText: "Assign character to location",
    );
  }
}
