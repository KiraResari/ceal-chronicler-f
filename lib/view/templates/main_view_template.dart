import '../../main_view/main_view_candidate.dart';

abstract class MainViewTemplate{
  MainViewCandidate get associatedView;

  bool get isValid;
}