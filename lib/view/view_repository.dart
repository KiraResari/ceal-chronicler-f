import '../main_view/main_view_candidate.dart';
import 'templates/main_view_template.dart';
import 'templates/overview_view_template.dart';

class ViewRepository {
  MainViewTemplate mainViewTemplate = OverviewViewTemplate();

  MainViewCandidate get mainView => mainViewTemplate.associatedView;

}
