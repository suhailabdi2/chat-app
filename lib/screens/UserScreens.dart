import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class UserScreens extends GetView<AuthController> {
  UserScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chats = controller.chats;
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where(
                          'uid',
                          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        Get.snackbar('Error', snapshot.error.toString());
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      ;
                      final data = snapshot.data!.docs;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, i) {
                            var userDoc = data[i];
                            final user = userDoc.data() as Map<String, dynamic>;
                            print(user['uid']);
                            return ListTile(
                              title: Text(user['email']),
                              subtitle: Text(user['phoneNumber']),
                              onTap: () {
                                if (user.containsKey('uid')) {
                                  Get.toNamed(
                                    '/chat',
                                    arguments: {
                                      "receiverUID": user['uid'],
                                      "chatId": "${FirebaseAuth.instance.currentUser!.uid}-${user['uid']}",
                                    },
                                  );
                                }
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
