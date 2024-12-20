import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../key_fields/location_id_key_field.dart';
import '../../key_fields/widgets/next_key_button.dart';
import '../../key_fields/widgets/previous_key_button.dart';
import '../../key_fields/widgets/toggle_key_button.dart';
import '../model/location_id.dart';
import 'location_id_key_field_controller.dart';

class LocationIdKeyFieldView extends StatelessWidget {
  final LocationIdKeyField keyField;

  const LocationIdKeyFieldView(this.keyField, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationIdKeyFieldController(keyField),
      builder: (context, child) => _buildView(context),
    );
  }

  Widget _buildView(BuildContext context) {
    return Row(
      children: [
        _buildPresentLocationDropdown(context),
        _buildPreviousKeyButton(context),
        _buildAddOrRemoveKeyButton(context),
        _buildNextKeyButton(context),
      ],
    );
  }

  Widget _buildPreviousKeyButton(BuildContext context) {
    var controller = context.read<LocationIdKeyFieldController>();
    bool enabled = context.watch<LocationIdKeyFieldController>().hasPrevious;
    return PreviousKeyButton(controller, enabled);
  }

  Widget _buildNextKeyButton(BuildContext context) {
    var controller = context.read<LocationIdKeyFieldController>();
    bool enabled = context.watch<LocationIdKeyFieldController>().hasNext;
    return NextKeyButton(controller, enabled);
  }

  Widget _buildAddOrRemoveKeyButton(BuildContext context) {
    var controller = context.read<LocationIdKeyFieldController>();
    bool keyExistsAtCurrentPointInTime = context
        .watch<LocationIdKeyFieldController>()
        .keyExistsAtCurrentPointInTime;
    return ToggleKeyButton(controller, keyExistsAtCurrentPointInTime);
  }

  Widget _buildPresentLocationDropdown(BuildContext context) {
    var controller = context.read<LocationIdKeyFieldController>();
    LocationId presentLocation =
        context.watch<LocationIdKeyFieldController>().presentLocation;
    List<DropdownMenuEntry<LocationId>> entries =
        context.watch<LocationIdKeyFieldController>().validLocationEntries;

    return DropdownMenu<LocationId>(
      initialSelection: presentLocation,
      dropdownMenuEntries: entries,
      onSelected: (LocationId? locationId) {
        controller.updatePresentLocation(locationId);
      },
    );
  }
}
