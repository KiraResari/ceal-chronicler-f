import 'package:flutter/material.dart';

import '../../../characters/model/character.dart';
import '../../../get_it_context.dart';
import '../../../key_fields/widgets/key_field_controller.dart';
import '../../../timeline/model/point_in_time_id.dart';
import '../../model/party.dart';
import '../../model/party_id.dart';
import '../../model/party_repository.dart';

class PartyIdKeyFieldPanelController extends KeyFieldController<PartyId?> {

  static final nonePartyId = PartyId();
  static final DropdownMenuEntry<PartyId> noneEntry =
      DropdownMenuEntry<PartyId>(value: nonePartyId, label: "none");
  final _partyRepository = getIt.get<PartyRepository>();
  final Character character;

  PartyIdKeyFieldPanelController(this.character, super.keyField);

  Party? get presentParty {
    if (currentValue != null) {
      return _partyRepository.getContentElementById(currentValue!);
    }
    return null;
  }

  List<DropdownMenuEntry<PartyId>> get validPartyEntries {
    List<Party> validParies = _validParties;
    List<DropdownMenuEntry<PartyId>> entries = validParies
        .map((location) => _mapToDropdownMenuEntry(location))
        .toList();
    entries.add(noneEntry);
    return entries;
  }

  List<Party> get _validParties {
    return _partyRepository.content
        .where((location) =>
            pointInTimeRepository.entityIsPresentlyActive(location))
        .toList();
  }

  DropdownMenuEntry<PartyId> _mapToDropdownMenuEntry(
    Party location,
  ) {
    String name = keyFieldResolver.getCurrentValue(location.name) ?? "";
    return DropdownMenuEntry<PartyId>(value: location.id, label: name);
  }

  void updateParty(PartyId? id) {
    if (id != null) {
      if (id == nonePartyId) {
        updateKey(null);
      } else {
        updateKey(id);
      }
    }
  }
}
