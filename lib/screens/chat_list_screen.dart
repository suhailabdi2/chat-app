import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ChatListScreen extends GetView<AuthController> {
  ChatListScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
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
                FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.search, color: Colors.black),
                  backgroundColor: const Color(0xFF00FF85),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          StreamBuilder(stream: FirebaseFirestore.instance.collection('chats').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Text("Error ${snapshot.error}");
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                final chats = snapshot.data!.docs;

                return Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: chats.length,
                    separatorBuilder: (index,context) => const Divider(height: 1, color: Colors.white12),
                    itemBuilder: (context, i) {
                      final chat = chats[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF00FF85),
                          child: Text("${i+1}"),
                        ),
                        title: Text("${chat.data()['receiverID']}"),
                        onTap: () => Get.toNamed('/chat', arguments: {"chatId":chat.id,"receiverUID":chat.data()['receiverID']}),
                      );
                    },
                  ),
                );
              },),
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