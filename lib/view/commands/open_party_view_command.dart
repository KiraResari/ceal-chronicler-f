import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../parties/model/party.dart';
import '../templates/party_view_template.dart';
import 'change_main_view_command.dart';

class OpenPartyViewCommand extends ChangeMainViewCommand {
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  Party party;

  OpenPartyViewCommand(this.party) : super(PartyViewTemplate(party));

  @override
  String toString() {
    return 'OpenPartyViewCommand{Target: $party; Can execute: $isRedoPossible; Can undo: $isUndoPossible}';
  }

  String get getCharacterNameOrUnknown {
    String? name = _keyFieldResolver.getCurrentValue(party.name);
    return name ?? "unknown";
  }
}
