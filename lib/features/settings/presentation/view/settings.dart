import 'package:flutter/material.dart';
import 'package:pet_alert_app/features/auth/presentation/view/login_page.dart';
import 'widgets/about_us_screen.dart';
import 'widgets/contact_us_screen.dart';
import 'widgets/faq_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> handleLogout(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

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
            colors: [Colors.deepPurple, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Settings",
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
          children: [
            /// About Us
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD1C4E9), Color(0xFFB2EBF2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.black),
                    title: const Text("About Us"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => navigateTo(context, const AboutUsScreen()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.contact_mail, color: Colors.black),
                    title: const Text("Contact Us"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => navigateTo(context, const ContactUsScreen()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: Colors.black),
                    title: const Text("FAQ"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => navigateTo(context, const FAQScreen()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// Logout
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B3F72), Color(0xFF00B4DB)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton.icon(
                onPressed: () => handleLogout(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  "Logout",
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
