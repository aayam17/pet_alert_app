import 'package:flutter/material.dart';

class VetAppointmentsScreen extends StatelessWidget {
  const VetAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_hospital, size: 100, color: Colors.pink),
            SizedBox(height: 20),
            Text(
              'Vet Appointments',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
