import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message_bar_controller.dart';

class MessageBar extends StatelessWidget {
  const MessageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageBarController(),
      builder: (context, child) => _buildMessageBar(context),
    );
  }

  Widget _buildMessageBar(BuildContext context) {
    String message = context.watch<MessageBarController>().message;
    String viewProcessorHistoryState =
        context.watch<MessageBarController>().viewProcessorHistoryState;
    int viewProcessorHistoryIndex =
        context.watch<MessageBarController>().viewProcessorHistoryIndex;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        children: [
          Text(message),
          Text(viewProcessorHistoryState),
          Text("ViewProcessorHistoryIndex: $viewProcessorHistoryIndex"),
        ],
      ),
    );
  }
}
