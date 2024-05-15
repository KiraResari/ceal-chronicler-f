import '../commands/processor_listener.dart';
import '../get_it_context.dart';
import '../view/view_repository.dart';
import 'main_view_candidate.dart';

class MainViewController extends ProcessorListener {
  final _viewRepository = getIt.get<ViewRepository>();

  MainViewController() : super();

  MainViewCandidate get activeView => _viewRepository.mainView;
}
