import 'package:chatify_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: FormBuilder(
              key: controller.signupFormKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Create an Account',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your credentials",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FormBuilderTextField(
                      name: "emailSignUp",
                      controller: controller.emailSignUpController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Enter your Email',
                        prefixIcon: Icon(Icons.email, color: Color(0xFF00FF85)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: "phoneNumberSignUp",
                      controller: controller.phoneNumberController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Enter your Name',
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF00FF85)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        if (value.length != 10) {
                          return 'Phone number must be 10 digits';
                        }
                        if (!RegExp(r'^07\d{8}$').hasMatch(value)) {
                          return 'Enter a Kenyan number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return FormBuilderTextField(
                        name: "passwordSignUp",
                        obscureText: controller.isPasswordHidden2.value,
                        controller: controller.passwordSignInController,
                        decoration: InputDecoration(
                          labelText: 'Enter your Password',
                          prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFF00FF85)),
                          suffixIcon: IconButton(
                            icon: Icon(
                                controller.isPasswordHidden2.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white),
                            onPressed: () {
                              controller.isPasswordHidden2.value =
                              !controller.isPasswordHidden2.value;
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 32),
                    Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.signup,
                        child: controller.isLoading.value
                            ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                            : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Sign Up'),
                        ))),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      child: const Text('Login'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    )
                  ]
              )
          ),
        ),
      ),
    );
  }
}
