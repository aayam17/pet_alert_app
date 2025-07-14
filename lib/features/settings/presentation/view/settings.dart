import 'package:flutter/material.dart';
import 'widgets/about_us_screen.dart';
import 'widgets/contact_us_screen.dart';
import 'widgets/faq_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  void navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void handleLogout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out.")),
    );
    // Navigate to login screen if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3FDFD),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          /// Notifications toggle
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: notificationsEnabled,
            activeColor: Colors.teal,
            onChanged: (val) {
              setState(() {
                notificationsEnabled = val;
              });
            },
          ),

          /// Dark Mode toggle
          SwitchListTile(
            title: const Text("Enable Dark Mode"),
            value: darkModeEnabled,
            activeColor: Colors.teal,
            onChanged: (val) {
              setState(() {
                darkModeEnabled = val;
              });
            },
          ),

          const SizedBox(height: 20),

          /// About Us
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.teal),
            title: const Text("About Us"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => navigateTo(const AboutUsScreen()),
          ),

          /// Contact Us
          ListTile(
            leading: const Icon(Icons.contact_mail, color: Colors.teal),
            title: const Text("Contact Us"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => navigateTo(const ContactUsScreen()),
          ),

          /// FAQ
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.teal),
            title: const Text("FAQ"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => navigateTo(const FAQScreen()),
          ),

          const SizedBox(height: 40),

          /// Logout button
          Center(
            child: TextButton.icon(
              onPressed: handleLogout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }
}
