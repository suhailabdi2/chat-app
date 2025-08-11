import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChatController {
  //   generate the chat id
  String generateChatId(String receiverUID) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final ids = [currentUserId, receiverUID];
    ids.sort();
    return ids.join("-");
  }

  // create the chat
  Future<String> createChat(String receiverUID, String receiverName) async {
    final currentUID = FirebaseAuth.instance.currentUser!.uid;
    final chatId = generateChatId(receiverUID);
    DocumentReference chatDoc = FirebaseFirestore.instance
        .collection('chats')
        .doc(generateChatId(receiverUID));
    chatDoc.set({
      "messages": [],
      "receiverID": receiverUID,
      "receiverEmail": receiverName,
      "createdBy": FirebaseAuth.instance.currentUser!.uid,
      "chatId": generateChatId(receiverUID),
    });
    updateMyChats(receiverUID, receiverName, generateChatId(receiverUID));
    CollectionReference myChats = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("myChats");
    await myChats.doc(generateChatId(receiverUID)).set({
      "chatId": generateChatId(receiverUID),
      "receiverEmail": receiverName,
      "receiverID": receiverUID,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverUID)
        .collection("myChats")
        .doc(chatId)
        .set({
      "chatId": chatId,
      "receiverEmail": FirebaseAuth.instance.currentUser!.email,
      "receiverID": currentUID,
      "senderId": receiverUID,
    });
    return chatId;
  }

  //update the myChats collection
  Future<void> updateMyChats(
    String receiverUID,
    String receiverEmail,
    String chatId,
  ) async {
    CollectionReference myChats = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('myChats');
    myChats.add({
      "receiverID": receiverUID,
      "receiverEmail": receiverEmail,
      "chatId": chatId,
    });
  }

  // check if the chat already exists
  Future<bool> checkChatExists(String receiverUID) async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(generateChatId(receiverUID))
        .get();
    return chatDoc.exists;
  }

  // compose the senders to chatscreen
  Map<String, dynamic> senderPayload(String chatId, String receiverUID) {
    return {"chatId": chatId, "receiverUID": receiverUID};
  }

  //send user to chatScreen
  Future<void> sendUserToChatScreen(
    String receiverUID,
    String receiverName,
  ) async {
    if (await checkChatExists(receiverUID)) {
      print("Chat already exists");

      Get.toNamed(
        '/chat',
        arguments: {
          "chatId": generateChatId(receiverUID),
          "receiverUID": receiverUID,
        },
      );
    } else {
      final newChatId = await createChat(receiverUID, receiverName);
      Get.toNamed(
        '/chat',
        arguments: {"chatId": newChatId, "receiverUID": receiverUID},
      );
    }
  }

  // compose the payload to send
  Map<String, dynamic> messagePayload(String receiverUID, String message) {
    return {
      "from": FirebaseAuth.instance.currentUser!.uid,
      "to": receiverUID,
      "message": message,
      "createdAt": "${DateTime.now().hour}:${DateTime.now().minute}",
      "chatId": generateChatId(receiverUID),
    };
  }

  Future getMessages(String chatID) async {
    var chatDoc = FirebaseFirestore.instance.collection('chats');
    chatDoc.doc(chatID).get().then((value) {
      print(value.data()!['messages']);
    });
  }

  // send the chat message to the server
  Future sendIndividualMessage(String receiverUID, String message) async {
    DocumentReference chatDoc = FirebaseFirestore.instance
        .collection('chats')
        .doc(generateChatId(receiverUID));
    chatDoc.update({"messages": messagePayload(receiverUID, message)});
  }

  // send the chat message to the server
  Future sendExistingIndividualMessage(
    String chatID,
    String message,
    String receiverUID,
  ) async {
    var chatDoc = FirebaseFirestore.instance.collection('chats');
    chatDoc.doc(chatID).get().then((value) {
      List results = value.data()!['messages'];
      results.add(messagePayload(receiverUID, message));
      print(results);
      chatDoc.doc(chatID).update({"messages": results});
    });
  }

  //delete chat
  Future deleteChat(String chatID) async {
    DocumentReference chatDoc = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID);
    chatDoc.delete();
    CollectionReference myChats = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('myChats');
    myChats.where('chatId', isEqualTo: chatID).get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }
}
