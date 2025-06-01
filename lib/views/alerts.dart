import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: const Center(
        child: Text(
          'No alerts at the moment.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
