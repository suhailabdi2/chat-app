import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  //   generate the chat id
  String generateChatId(String receiverUID) {
    return "${FirebaseAuth.instance.currentUser!.uid}-$receiverUID";
  }

  // compose the payload to send
  Map<String, dynamic> messagePayload(String receiverUID, String message) {
    return {
      "from": FirebaseAuth.instance.currentUser!.uid,
      "to": receiverUID,
      "message": message,
      "createdAt": "${DateTime.now().hour}/${DateTime.now().minute}",
      "chatId": generateChatId(receiverUID),
    };
  }

  // send the chat message to the server
  Future sendIndividualMessage(String receiverUID, String message) async {
    DocumentReference chatDoc = FirebaseFirestore.instance
        .collection('chats')
        .doc(generateChatId(receiverUID));
    chatDoc.update({"messages": messagePayload(receiverUID, message)});
  }

  // send the chat message to the server
  Future sendExistingIndividualMessage(String chatID, String message,String receiverUID) async {
    var chatDoc = FirebaseFirestore.instance
        .collection('chats')
        ;

    chatDoc.doc(chatID).get().then((value){
     List results = value.data()!['messages'];

     results.add(messagePayload(receiverUID, message));
     print(results);
      chatDoc.doc(chatID).update({"messages": results});
    });

    // items.add(messagePayload(receiverUID, message));
    // await chatDoc.doc(chatID).update({"messages": items});
    // print(items);

    // current list of messages
    // chatDoc.update({"messages": messagePayload(receiverUID, message)});
  }
}
