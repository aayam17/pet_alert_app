import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("About PetAlert"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About PetAlert",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Caring for your pets with innovation and love.",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "At PetAlert, we are passionate about connecting pet owners with trusted veterinary services and resources to ensure your beloved companions enjoy a happy, healthy life.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              "Our mission is to foster a supportive community where pets and their families receive expert care combined with cutting-edge technology, making pet care seamless and accessible.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              "From managing vaccination records to scheduling vet appointments, lost & found boards, and heartfelt memorials, PetAlert is your all-in-one trusted partner for pet care.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
