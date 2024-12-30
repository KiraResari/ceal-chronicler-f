import 'package:flutter/material.dart';

import '../../utils/widgets/overview.dart';
import '../model/party.dart';
import 'add_party_button.dart';
import 'party_button.dart';
import 'party_overview_controller.dart';


class PartyOverview
    extends Overview<Party, PartyOverviewController> {
  const PartyOverview({super.key});

  @override
  PartyOverviewController createController() {
    return PartyOverviewController();
  }

  @override
  Color get backgroundColor => Colors.pink;

  @override
  String get title => "Parties";

  @override
  List<Party> getItems(PartyOverviewController controller) {
    return controller.entitiesAtActivePointInTime;
  }

  @override
  Widget buildItem(Party item) {
    return PartyButton(item);
  }

  @override
  Widget buildAddButton() {
    return AddPartyButton();
  }
}
