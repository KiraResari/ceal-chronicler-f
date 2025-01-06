import '../../../../commands/command.dart';
import '../model/attribute.dart';

class EditAttributeLabelCommand extends Command {
  final Attribute attribute;
  final String newLabel;
  String? _oldLabel;

  EditAttributeLabelCommand(this.attribute, this.newLabel);

  @override
  void execute() {
    _oldLabel = attribute.label;
    attribute.label = newLabel;
  }

  @override
  String get executeMessage =>
      "Changed attribute label from '$_oldLabelOrUnknown' to $newLabel";

  @override
  void undo() {
    if (_oldLabel != null) {
      attribute.label = _oldLabel!;
    }
  }

  @override
  String get undoMessage =>
      "Changed attribute label back from '$newLabel' to $_oldLabelOrUnknown";

  String get _oldLabelOrUnknown {
    if (_oldLabel != null) {
      return _oldLabel!;
    }
    return "Unknown";
  }
}
