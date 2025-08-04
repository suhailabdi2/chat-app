import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AuthController extends GetxController {
  // State
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  final loginFormKey = GlobalKey<FormBuilderState>();
  final otpFormKey = GlobalKey<FormBuilderState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final textFieldController = TextEditingController();
  RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  RxList<Map<String,String>> chats = <Map<String,String>>[].obs;
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
  void send() async{
    messages.add({"from": "me", "text": textFieldController.text});
    textFieldController.clear();
    print(messages);
    await Future.delayed(const Duration(seconds: 1));
    messages.add({"from": "Alice", "text": "Hey!"});
  }
  // Mock OTP verify
  void verifyOtp() async {
    if (!(otpFormKey.currentState?.saveAndValidate() ?? false)) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.offAllNamed('/home');
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