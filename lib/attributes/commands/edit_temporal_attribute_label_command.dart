import '../../../../commands/command.dart';
import '../model/temporal_attribute.dart';

class EditTemporalAttributeLabelCommand extends Command {
  final TemporalAttribute attribute;
  final String newLabel;
  String? _oldLabel;

  EditTemporalAttributeLabelCommand(this.attribute, this.newLabel);

  @override
  void execute() {
    _oldLabel = attribute.label;
    attribute.label = newLabel;
  }

  @override
  String get executeMessage =>
      "Changed temporal attribute label from '$_oldLabelOrUnknown' to $newLabel";

  @override
  void undo() {
    if (_oldLabel != null) {
      attribute.label = _oldLabel!;
    }
  }

  @override
  String get undoMessage =>
      "Changed temporal attribute label back from '$newLabel' to $_oldLabelOrUnknown";

  String get _oldLabelOrUnknown {
    if (_oldLabel != null) {
      return _oldLabel!;
    }
    return "Unknown";
  }
}
