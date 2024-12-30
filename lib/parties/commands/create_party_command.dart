import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../view/templates/main_view_template.dart';
import '../../view/templates/overview_view_template.dart';
import '../../view/templates/party_view_template.dart';
import '../../view/view_repository.dart';
import '../model/party.dart';
import '../model/party_repository.dart';

class CreatePartyCommand extends Command {
  final _partyRepository = getIt.get<PartyRepository>();
  final _viewRepository = getIt.get<ViewRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final PointInTimeId _pointId;
  Party? _createdParty;

  CreatePartyCommand(this._pointId);

  @override
  void execute() {
    _createdParty ??= Party(_pointId);
    _partyRepository.add(_createdParty!);
  }

  @override
  String get executeMessage => "Created new Party";

  @override
  void undo() {
    if (_createdParty != null) {
      _partyRepository.remove(_createdParty!);
      _returnToOverviewViewIfPartyViewWasOpen();
    }
  }

  void _returnToOverviewViewIfPartyViewWasOpen() {
    MainViewTemplate mainViewTemplate = _viewRepository.mainViewTemplate;
    if (mainViewTemplate is PartyViewTemplate &&
        mainViewTemplate.entity == _createdParty!) {
      _viewRepository.mainViewTemplate = OverviewViewTemplate();
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of Party $_nameOrNothing";

  String get _nameOrNothing {
    if (_createdParty != null) {
      String? name = _keyFieldResolver.getCurrentValue(_createdParty!.name);
      return name != null ? "'$name'" : "";
    }
    return "";
  }
}
