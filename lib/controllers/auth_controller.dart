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
  final phoneNumber=''.obs;
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
  RxList<Map<String,String>> chats = <Map<String,String>>[].obs;
  final phoneNumberController = TextEditingController();

  // Mock login
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
          Get.offAllNamed('/otp');
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

        Future.delayed(const Duration(seconds: 3),(){
          print("Signup Successful");
          isLoading.value=false;
          Get.offAllNamed('/otp');
        });
        FirebaseFirestore.instance.collection('users').add({
          'email': emailSignUpController.text,
          'password': passwordSignInController.text,
          'phoneNumber': phoneNumberController.text,
        });

      }on FirebaseAuthException catch(e){
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
    if (otpFormKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        QuerySnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: emailController.text.trim())
            .get();
        if(doc.docs.isNotEmpty){
          var user1 = doc.docs[0];
          var userEmail = user1['email'];
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
        }

    } catch(e){
        Get.snackbar("Error", e.toString());
        isLoading.value=false;
      }
    }
  }
  void send() async{
    messages.add({"from": "me", "text": textFieldController.text});
    textFieldController.clear();
    print(messages);
    await Future.delayed(const Duration(seconds: 1));
    messages.add({"from": "Alice", "text": "Hey!"});
  }
  // Mock OTP verify
  void verifyOtp() async {
    if (otpFormKey.currentState!.validate()) {

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
} 