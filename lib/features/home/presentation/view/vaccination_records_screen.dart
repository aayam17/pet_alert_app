import 'package:flutter/material.dart';

class VaccinationRecordsScreen extends StatelessWidget {
  const VaccinationRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vaccination Records")),
      body: const Center(
        child: Text(
          "Vaccination Records Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
