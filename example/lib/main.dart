import 'package:flutter/material.dart';
import 'package:hubchat/hubchat.dart';

final hubChat = HubChatController(widgetKey: 'hc_xxxxxxxxxxxxxxxxxxxxxxxx');

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HubChat example',
      builder: (context, child) => HubChat(controller: hubChat, child: child!),
      home: Scaffold(
        appBar: AppBar(title: const Text('HubChat')),
        body: Center(
          child: ElevatedButton(onPressed: hubChat.open, child: const Text('Chat with support')),
        ),
      ),
    );
  }
}
