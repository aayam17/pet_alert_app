import 'package:flutter/material.dart';
import 'package:pet_alert_app/features/auth/presentation/view/login_page.dart';
import 'home.dart';
import 'vet_appointments.dart';
import 'lost_and_found.dart';
import 'profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    VetAppointmentsScreen(),
    LostAndFoundScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Vet Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Lost & Found',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.login),
        tooltip: 'Go to Login',
      ),
    );
  }
}
