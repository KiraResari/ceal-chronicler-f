import '../../utils/widgets/buttons/edit_button.dart';
import '../model/location.dart';
import '../model/location_level.dart';
import 'edit_location_level_button_controller.dart';

class EditLocationLevelButton extends EditButton<LocationLevel> {
  EditLocationLevelButton(Location locationBeingEdited, {super.key})
      : super(
          controller: EditLocationLevelButtonController(locationBeingEdited),
          initialSelection: locationBeingEdited.locationLevel,
          labelText: "Select location level",
        );
}
