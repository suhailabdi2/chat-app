import 'package:chatify_app/controllers/auth_controller.dart';
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
    final String chatName = Get.arguments ?? 'Chat';
    return Scaffold(
      appBar: AppBar(title: Text(chatName)),
      body: Column(
          children: [
      Expanded(
      child:StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('chats').doc(controller.getChatId(
          FirebaseAuth.instance.currentUser!.uid, chatName)).
      collection('messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Get.snackbar('Error', snapshot.error.toString());
        };
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        };
        final data = snapshot.data!.docs;

        return data.isNotEmpty ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, i) {
                var msg = data[i];
                var isMe = msg['from'] ==
                    FirebaseAuth.instance.currentUser!.uid;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment
                      .centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF00FF85) : const Color(
                          0xFF23272A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(color: isMe ? Colors.black : Colors
                          .white),
                    ),
                  ),
                );
              }
          ) : Center(child: Text("No Texts Found"),);


      },

    ),

    // return ListView.builder(
    //   padding: const EdgeInsets.all(16),
    //   itemCount: data,
    //   itemBuilder: (context, i) {
    //     var msg = controller.messages[i];
    //     var isMe = msg['from'] == 'me';
    //     return Align(
    //         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    //         child: Container(
    //           margin: const EdgeInsets.symmetric(vertical: 4),
    //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //           decoration: BoxDecoration(
    //             color: isMe ? const Color(0xFF00FF85) : const Color(0xFF23272A),
    //             borderRadius: BorderRadius.circular(16),
    //           ),
    //           child: Text(
    //             msg['text']!,
    //             style: TextStyle(color: isMe ? Colors.black : Colors.white),
    //           ),
    //         ),
    //       );
    //     }
    //   ,
    // );

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
    onPressed: (){
    if(controller.textFieldController.text.isNotEmpty){
    controller.sendMessage(
    senderId: FirebaseAuth.instance.currentUser!.uid,
    receiverId: chatName,
    text: controller.textFieldController.text,
    );
    controller.textFieldController.clear();
    }
    },
    ),
    ],
    ),
    ),
    ],
    )
    ,
    );
  }
}
