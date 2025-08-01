import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:pet_alert_app/features/community%20board/presentation/view/community_board_screen.dart';
import '../../../vet appointments/presentation/view/vet_appointments_screen.dart';
import '../../../vaccination records/presentation/view/vaccination_records_screen.dart';
import '../../../lost and found/presentation/view/lost_and_found.dart';
import '../../../memorials/presentation/view/memorials_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool showNotifications = false;
  final List<String> notifications = [
    "🐶 New Lost Pet in Lazimpat",
    "🕊️ Memorial Tribute added for Bella",
  ];

  static const double shakeThreshold = 15.0;
  DateTime lastShakeTime = DateTime.now();

  Light? _lightSensor;
  Stream<int>? _lightStream;
  int _lastLuxLevel = -1;

  @override
  void initState() {
    super.initState();
    _startShakeListener();
    _startLightSensor();
  }

  void _startShakeListener() {
    accelerometerEvents.listen((event) {
      final double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      final now = DateTime.now();
      final timeDiff = now.difference(lastShakeTime);

      if (acceleration > shakeThreshold && timeDiff.inMilliseconds > 1000) {
        lastShakeTime = now;
        _navigateToCommunityBoard();
      }
    });
  }

  void _navigateToCommunityBoard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CommunityBoardScreen()),
    );
  }

  void _startLightSensor() {
    _lightSensor = Light();
    _lightStream = _lightSensor!.lightSensorStream;

    _lightStream!.listen((lux) {
      if (_lastLuxLevel == -1 ||
          (lux < 10 && _lastLuxLevel >= 10) ||
          (lux > 100 && _lastLuxLevel <= 100)) {
        _lastLuxLevel = lux;

        if (lux < 10) {
          _showSnackBar("🌙 Low light detected!");
        } else if (lux > 100) {
          _showSnackBar("☀️ Bright environment detected!");
        }
      }
    }, onError: (err) {
      debugPrint("Light sensor error: $err");
    });
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          "PetAlert",
                          style: TextStyle(
                            color: Color(0xFF4B3F72),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none,
                                color: Color(0xFF4B3F72), size: 28),
                            onPressed: () =>
                                setState(() => showNotifications = !showNotifications),
                          ),
                          if (notifications.isNotEmpty)
                            Positioned(
                              right: 6,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE74C3C),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${notifications.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    "A four-legged word: LOVE",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B3F72),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Providing expert pet care services online.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF555E68),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CommunityBoardScreen()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[200],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.blueGrey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Go to Community Board",
                          style: TextStyle(
                            color: Color(0xFF2D2D2D),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Explore Services",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B3F72),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: [
                      _buildAnimatedGridCard(
                        icon: Icons.local_hospital_rounded,
                        title: "Vet Appointments",
                        subtitle: "Book & track vet visits",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VetAppointmentsScreen()),
                        ),
                      ),
                      _buildAnimatedGridCard(
                        icon: Icons.vaccines_rounded,
                        title: "Vaccination",
                        subtitle: "Manage vaccinations",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VaccinationRecordsScreen()),
                        ),
                      ),
                      _buildAnimatedGridCard(
                        icon: Icons.search,
                        title: "Lost & Found",
                        subtitle: "Report or search pets",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LostAndFoundScreen()),
                        ),
                      ),
                      _buildAnimatedGridCard(
                        icon: Icons.favorite_border,
                        title: "Memorials",
                        subtitle: "Tributes & memories",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MemorialsScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showNotifications)
              Positioned(
                top: kToolbarHeight + 8,
                right: 16,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: notifications
                          .map(
                            (note) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.pets,
                                      size: 18, color: Color(0xFF4B3F72)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      note,
                                      style: const TextStyle(
                                          color: Color(0xFF1F1F1F)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF4B3F72)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFF555E68)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
