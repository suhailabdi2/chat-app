import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF00FF85),
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text("Suhail Abdi", style: TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 8),
            Text(user?.email ?? "No Email Found", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.offAllNamed('/login');
                Get.snackbar('Logout', 'You have been logged out');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00FF85),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 