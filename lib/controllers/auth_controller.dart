import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:math';
class AuthController extends GetxController {
  // State
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool isPasswordHidden2 = true.obs;
  final loginFormKey = GlobalKey<FormBuilderState>();
  final otpFormKey = GlobalKey<FormBuilderState>();
  final signupFormKey = GlobalKey<FormBuilderState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final textFieldController = TextEditingController();
  final emailSignUpController = TextEditingController();
  final passwordSignInController = TextEditingController();
  RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  RxList<Map<String,String>> chats = <Map<String,String>>[{"name": "Suhail","last": "Hello"},
    {"name": "Sharon","last":"Hi" },
    {"name":"Kagia","last":"Hey"}
  ].obs;

  final phoneNumberController = TextEditingController();
  void login() async {
    String message = '';
    if(loginFormKey.currentState!.validate()){
      try{
        isLoading.value=true;
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Future.delayed(const Duration(seconds: 3),(){
          print("Login Successful");
          isLoading.value=false;
          emailController.clear();
          passwordController.clear();
          isLoading.value=false;
          Get.offAllNamed('/home');
        });
      }on FirebaseAuthException catch(e){
        if(e.code=='INVALID_LOGIN_CREDENTIALS'){
          message= 'Invalid email or password';
        } else{
          message = e.code;
          print(e);
          print(passwordController.text);
        }
        Get.snackbar('Error', message);
        isLoading.value=false;
      }
    }
  }

  void signup() async {
    if(signupFormKey.currentState!.validate()){
      try{
        isLoading.value=true;
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailSignUpController.text,
          password: passwordSignInController.text,
        );
        FirebaseFirestore.instance.collection('users').add({
          'email': emailSignUpController.text,
          'password': passwordSignInController.text,
          'phoneNumber': phoneNumberController.text,
          'uid':FirebaseAuth.instance.currentUser!.uid,
        });
        Future.delayed(const Duration(seconds: 3),(){
          print("Signup Successful");
          isLoading.value=false;
          Get.offAllNamed('/otp');
        });
      }
      on FirebaseAuthException catch(e){
          if(e.code=='email-already-exists'){
            Get.toNamed('/login');
            Get.snackbar('Error', 'Email already exists');

          } else{
              Get.snackbar('Error', e.code);
          }
          isLoading.value=false;
      }

    }

  }
  void sendOTP() async {
      try {
        isLoading.value = true;
        var userEmail = FirebaseAuth.instance.currentUser!.email.toString();
         EmailOTP.config(
           appName: "Chatify App",
           otpType: OTPType.numeric,
           expiry : 30000,
           emailTheme: EmailTheme.v6,
           appEmail: 'linkedsuhail@gmail.com',
           otpLength: 4,
         );
          isLoading.value = false;
          EmailOTP.sendOTP(email: userEmail);


    } catch(e){
        Get.snackbar("Error", e.toString());
        isLoading.value=false;
      }

  }

  void verifyOtp() async {
    if (otpFormKey.currentState!.validate()) {
      if (EmailOTP.verifyOTP(otp: otpControllers[0].text+otpControllers[1].text+otpControllers[2].text+otpControllers[3].text)) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'Invalid OTP');
      }

    }
  }



  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    super.onClose();
  }
  Future<void>sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async{
    String chatId = getChatId(senderId, receiverId);
    DocumentReference chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);
    await chatDoc.collection('messages').add({
      'from': senderId,
      'text': text,
    });
    await chatDoc.update({
      'last': text,
      'lastSenderId': senderId,
    });
  }
  String getChatId(String uid, String rid) {
    return uid.hashCode <= rid.hashCode ? '$uid-$rid' : '$rid-$uid';
  }
}


