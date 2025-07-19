import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../../../vet appointments/presentation/view/vet_appointments_screen.dart';
import '../../../lost and found/presentation/view/lost_and_found.dart';
import '../../../settings/presentation/view/settings.dart';

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
    SettingsScreen(),
  ];

  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.local_hospital_rounded,
    Icons.search_rounded,
    Icons.settings_rounded,
  ];

  final List<String> labels = [
    'Home',
    'Vet',
    'Lost',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_currentIndex],

          /// Floating FAB without shadow or dark blur
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                  boxShadow: [], // no black blur underneath
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 28, color: Colors.black),
                  onPressed: () {
                    // TODO: Add action here
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      /// Blurred transparent nav bar (even under FAB)
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(icons.length, (index) {
                  final isSelected = _currentIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 6,
                          width: 6,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(
                          icons[index],
                          size: isSelected ? 26 : 24,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
