import 'package:flutter/material.dart';
import 'watson_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final WatsonService _watsonService = WatsonService();
  String _response = '';

  void _sendMessage() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      const userId = 'unique_user_id'; // Assign a unique ID for the user
      final response = await _watsonService.sendMessage(message, userId);
      setState(() {
        _response = response;
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Watson'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Text(_response),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your message',
              ),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
