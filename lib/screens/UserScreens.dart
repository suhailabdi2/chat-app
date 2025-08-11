import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';

class UserScreens extends GetView<AuthController> {
  UserScreens({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    final myChatsSnapshot = FirebaseFirestore.instance
        .collectionGroup("myChats")
        .where(
          "receiverID",
          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid,
        );
    final myChats = myChatsSnapshot.get();
    print(myChats);
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        Get.snackbar('Error', snapshot.error.toString());
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      };
                      final data = snapshot.data!.docs;
                      print(data);
                      return Expanded(
                        child: ListView.separated(
                          itemCount: data.length,
                          separatorBuilder: (index, context) => const Divider (height: 1,color: Colors.white12),
                          itemBuilder: (context, i) {
                            var userDoc = data[i];
                            final user = userDoc.data() as Map<String, dynamic>;
                            print(user['receiverEmail']);
                            return ListTile(
                              title: Text(user['email']),
                              leading: CircleAvatar(),
                              onTap: (){
                                chatController.sendUserToChatScreen(user['uid'], user['email']);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
