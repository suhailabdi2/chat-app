import 'package:chatify_app/controllers/auth_controller.dart';
import 'package:chatify_app/controllers/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ChatDetailScreen extends GetView<AuthController> {
  ChatDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    final String chatName = Get.arguments['chatId'] ?? 'Chat';
    return Scaffold(
      appBar: AppBar(title: Text(Get.arguments["receiverUID"])),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(Get.arguments['chatId'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Get.snackbar('Error', snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                };
                final data = snapshot.data!.data();
                final messages = data!['messages'];
                print(messages);
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment:
                          message['from'] == FirebaseAuth.instance.currentUser!.uid
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              message['from'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? const Color(0xFF00FF85)
                              : const Color(0xFF23272A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message['message'],
                          style:
                              message['from'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? const TextStyle(color: Colors.black)
                              : const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
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
                    controller: controller.textFieldController,
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
                  onPressed: () {
                    if (controller.textFieldController.text.isNotEmpty) {
                      chatController.sendExistingIndividualMessage(
                        chatName,
                        controller.textFieldController.text,
                        Get.arguments['receiverUID'],
                      );
                      controller.textFieldController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
