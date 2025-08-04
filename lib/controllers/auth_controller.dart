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
  // Mock login
  void login() async {
    if (!(loginFormKey.currentState?.saveAndValidate() ?? false)) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.toNamed('/otp');
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