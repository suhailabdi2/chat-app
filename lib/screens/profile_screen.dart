import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const Text('John Doe', style: TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 8),
            const Text('john.doe@email.com', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.offAllNamed('/login'),
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