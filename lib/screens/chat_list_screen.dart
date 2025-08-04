import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ChatListScreen extends GetView<AuthController> {
  ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chats = controller.chats;
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00FF85)),
                filled: true,
                fillColor: const Color(0xFF23272A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (index,context) => const Divider(height: 1, color: Colors.white12),
              itemBuilder: (context, i) {
                final chat = chats[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF00FF85),
                    child: Text(chat['name']![0]),
                  ),
                  title: Text(chat['name']!, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(chat['last']!, style: const TextStyle(color: Colors.white70)),
                  onTap: () => Get.toNamed('/chat', arguments: chat['name']),

                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00FF85),
        child: const Icon(Icons.chat, color: Colors.black),
        onPressed: () {},
      ),
    );
  }
} 