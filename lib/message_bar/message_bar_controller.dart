import '../commands/processor_listener.dart';
import '../get_it_context.dart';
import '../view/view_repository.dart';
import 'message_bar_state.dart';

class MessageBarController extends ProcessorListener {
  final _messageBarState = getIt.get<MessageBarState>();
  final _viewRepository = getIt.get<ViewRepository>();

  MessageBarController() : super();

  String get message => _messageBarState.statusMessage;

  String get mainViewTemplate => _viewRepository.mainViewTemplate.identifier;
}
