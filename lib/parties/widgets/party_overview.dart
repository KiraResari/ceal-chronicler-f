import 'package:ceal_chronicler_f/parties/widgets/add_party_button.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/overview.dart';
import '../model/party.dart';
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
    return const Text("Party");
  }

  @override
  Widget buildAddButton() {
    return AddPartyButton();
  }
}
