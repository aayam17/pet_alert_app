import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: const Center(
        child: Text(
          'Welcome to your profile!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
