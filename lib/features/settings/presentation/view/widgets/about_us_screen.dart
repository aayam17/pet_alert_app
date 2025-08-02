import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF4B3F72), Color(0xFF00B4DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "About PetAlert",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Caring for your pets with innovation and love.",
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 24),
            Text(
              "At PetAlert, we are passionate about connecting pet owners with trusted veterinary services and resources to ensure your beloved companions enjoy a happy, healthy life.",
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 16),
            Text(
              "Our mission is to foster a supportive community where pets and their families receive expert care combined with cutting-edge technology, making pet care seamless and accessible.",
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 16),
            Text(
              "From managing vaccination records to scheduling vet appointments, lost & found boards, and heartfelt memorials, PetAlert is your all-in-one trusted partner for pet care.",
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
