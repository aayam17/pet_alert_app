import 'package:flutter/material.dart';
import 'package:pet_alert_app/features/auth/presentation/view/login_page.dart';
import 'widgets/about_us_screen.dart';
import 'widgets/contact_us_screen.dart';
import 'widgets/faq_screen.dart';
import 'package:flutter/scheduler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  bool notificationsEnabled = true;
  bool darkModeEnabled = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  late final AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    if (darkModeEnabled) _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> handleLogout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  ThemeMode _getThemeMode() => darkModeEnabled ? ThemeMode.dark : ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _getThemeMode(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Settings", style: TextStyle(color: Color(0xFF4B3F72))),
          iconTheme: const IconThemeData(color: Color(0xFF4B3F72)),
          elevation: 1,
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            /// Notifications toggle
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: notificationsEnabled,
              activeColor: Colors.black,
              secondary: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                  key: ValueKey(notificationsEnabled),
                  color: Colors.black,
                ),
              ),
              onChanged: (val) {
                setState(() => notificationsEnabled = val);
              },
            ),

            /// Dark Mode toggle
            SwitchListTile(
              title: const Text("Enable Dark Mode"),
              value: darkModeEnabled,
              activeColor: Colors.black,
              secondary: AnimatedBuilder(
                animation: _iconController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _iconController.value * 3.14,
                    child: Icon(
                      darkModeEnabled ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              onChanged: (val) {
                setState(() {
                  darkModeEnabled = val;
                  if (val) {
                    _iconController.forward();
                  } else {
                    _iconController.reverse();
                  }
                });
              },
            ),

            const SizedBox(height: 20),

            /// About Us
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.black),
              title: const Text("About Us"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => navigateTo(const AboutUsScreen()),
            ),

            /// Contact Us
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.black),
              title: const Text("Contact Us"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => navigateTo(const ContactUsScreen()),
            ),

            /// FAQ
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black),
              title: const Text("FAQ"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => navigateTo(const FAQScreen()),
            ),

            const SizedBox(height: 40),

            /// Logout
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
      ),
    );
  }
}
