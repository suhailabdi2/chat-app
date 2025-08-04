import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDetailScreen extends StatelessWidget {
  ChatDetailScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> messages = [
    {'from': 'me', 'text': 'Hello!'},
    {'from': 'Alice', 'text': 'Hey!'},
    {'from': 'me', 'text': 'How are you?'},
    {'from': 'Alice', 'text': 'I\'m good!'},
  ];

  @override
  Widget build(BuildContext context) {
    final String chatName = Get.arguments ?? 'Chat';
    return Scaffold(
      appBar: AppBar(title: Text(chatName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];
                final isMe = msg['from'] == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF00FF85) : const Color(0xFF23272A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(color: isMe ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: const Color(0xFF23272A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: const Color(0xFF00FF85),
                  child: const Icon(Icons.send, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 