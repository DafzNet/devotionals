import 'package:flutter/material.dart';

import '../utils/models/chat.dart';

class ChatModelProvider extends ChangeNotifier {
  List<Chat> _chatMessages = [];

  List<Chat> get chatMessages => _chatMessages;

  void setChatMessages(List<Chat> messages) {
    _chatMessages = messages;
    notifyListeners();
  }
}
