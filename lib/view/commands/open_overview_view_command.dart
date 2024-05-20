import '../templates/overview_view_template.dart';
import 'change_main_view_command.dart';

class OpenOverviewViewCommand extends ChangeMainViewCommand {
  OpenOverviewViewCommand() : super(OverviewViewTemplate());

  @override
  String toString() {
    return 'OpenOverviewViewCommand';
  }
}
