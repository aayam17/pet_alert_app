import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "About PetAlert",
          style: TextStyle(
            color: Color(0xFF4B3F72),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4B3F72)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Caring for your pets with innovation and love.",
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "At PetAlert, we are passionate about connecting pet owners with trusted veterinary services and resources to ensure your beloved companions enjoy a happy, healthy life.",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Our mission is to foster a supportive community where pets and their families receive expert care combined with cutting-edge technology, making pet care seamless and accessible.",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "From managing vaccination records to scheduling vet appointments, lost & found boards, and heartfelt memorials, PetAlert is your all-in-one trusted partner for pet care.",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
