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
    with TickerProviderStateMixin {
  bool showNotifications = false;
  final List<String> notifications = [
    "🐶 New Lost Pet in Lazimpat",
    "🕊️ Memorial Tribute added for Bella",
  ];

  static const double shakeThreshold = 25.0;
  DateTime lastShakeTime = DateTime.now();

  Light? _lightSensor;
  Stream<int>? _lightStream;
  int _lastLuxLevel = -1;

  late AnimationController _textController;
  late Animation<Offset> _slideAnimation;

  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _startShakeListener();
    _startLightSensor();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _textController.forward();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _gradientController.dispose();
    super.dispose();
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
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF4B3F72), Color(0xFF00B4DB)],
                        ).createShader(bounds),
                        child: const Text(
                          "PetAlert",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined,
                                color: Color(0xFF4B3F72), size: 28),
                            onPressed: () =>
                                setState(() => showNotifications = !showNotifications),
                          ),
                          if (notifications.isNotEmpty)
                            Positioned(
                              right: 6,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${notifications.length}',
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 🟣 Animated Title with moving gradient
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: _gradientController,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: const [Colors.purple, Colors.cyan, Colors.teal],
                                  begin: Alignment(-1 + 2 * _gradientController.value, -1),
                                  end: Alignment(1 - 2 * _gradientController.value, 1),
                                ).createShader(bounds);
                              },
                              child: const Text(
                                "A four-legged word: LOVE",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        AnimatedBuilder(
                          animation: _gradientController,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: const [
                                    Colors.pink,
                                    Colors.indigoAccent,
                                    Colors.cyan
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    _gradientController.value - 0.2,
                                    _gradientController.value,
                                    _gradientController.value + 0.2,
                                  ].map((e) => e.clamp(0.0, 1.0)).toList(),
                                ).createShader(bounds);
                              },
                              child: const Text(
                                "Providing expert pet care services online.",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CommunityBoardScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4B3F72), Color(0xFF00B4DB)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Go to Community Board",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Explore Services",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                      _buildServiceCard(
                        icon: Icons.local_hospital_rounded,
                        title: "Vet Appointments",
                        subtitle: "Book & track vet visits",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VetAppointmentsScreen()),
                        ),
                      ),
                      _buildServiceCard(
                        icon: Icons.vaccines_rounded,
                        title: "Vaccination",
                        subtitle: "Manage vaccinations",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VaccinationRecordsScreen()),
                        ),
                      ),
                      _buildServiceCard(
                        icon: Icons.search,
                        title: "Lost & Found",
                        subtitle: "Report or search pets",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LostAndFoundScreen()),
                        ),
                      ),
                      _buildServiceCard(
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
                          .map((note) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
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
                              ))
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

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF4B3F72)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF555E68),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
