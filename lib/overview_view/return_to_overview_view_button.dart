import 'package:flutter/material.dart';

import '../get_it_context.dart';
import '../utils/widgets/buttons/medium_square_button.dart';
import '../view/commands/open_overview_view_command.dart';
import '../view/view_processor.dart';

class ReturnToOverviewViewButton extends MediumSquareButton {
  final _viewProcessor = getIt.get<ViewProcessor>();

  ReturnToOverviewViewButton({super.key}) : super(icon: Icons.arrow_upward);

  @override
  void onPressed(BuildContext context) {
    var command = OpenOverviewViewCommand();
    _viewProcessor.process(command);
  }

  @override
  String? get tooltip => "Return to overview";
}
