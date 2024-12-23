import '../../main_view/main_view_candidate.dart';
import '../../overview_view/overview_view.dart';
import 'main_view_template.dart';

class OverviewViewTemplate extends MainViewTemplate {
  @override
  MainViewCandidate get associatedView => const OverviewView();

  @override
  bool get isValid => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverviewViewTemplate && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String get identifier => "Overview View";
}
