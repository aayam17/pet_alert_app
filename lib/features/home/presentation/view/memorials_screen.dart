import 'package:flutter/material.dart';

class MemorialsScreen extends StatelessWidget {
  const MemorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Memorials")),
      body: const Center(
        child: Text(
          "Memorials Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
