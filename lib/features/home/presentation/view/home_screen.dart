import 'package:flutter/material.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  bool showNotifications = false;

  final List<String> notifications = [
    "New Lost Pet in Lazimpat 🐶",
    "Memorial Tribute added for Bella 🕊️",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
     appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  titleSpacing: 0, // removes default spacing
  title: Row(
    children: const [
      Padding(
        padding: EdgeInsets.only(left: 16),
        child: Text(
          "PetAlert",
          style: TextStyle(
            color: Color(0xFF5A4FCF),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    ],
  ),
  actions: [
    // Notification Icon
    Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Color(0xFF5A4FCF), size: 28),
          onPressed: () => setState(() => showNotifications = !showNotifications),
        ),
        if (notifications.isNotEmpty)
          Positioned(
            right: 6,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${notifications.length}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    ),
  ],
),

      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HERO SECTION
                  const Text(
                    "A four-legged word: LOVE",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4FCF),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Providing expert pet care services online.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// COMMUNITY BOARD BUTTON
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3C7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Color(0xFFFFD369)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CommunityBoardScreen()),
                        );
                      },

                        child: Center(
                          child: Text(
                            "Go to Community Board",
                            style: TextStyle(
                              color: Color(0xFF2D2D2D),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24), 

                  /// SECTION TITLE
                  const Text(
                    "Explore Services",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A4FCF),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// GRID SERVICE CARDS
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: [
                      _buildGridCard(
                        icon: Icons.local_hospital_rounded,
                        title: "Vet Appointments",
                        subtitle: "Book & track vet visits",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VetAppointmentsScreen()),
                        ),
                      ),
                      _buildGridCard(
                        icon: Icons.vaccines_rounded,
                        title: "Vaccination",
                        subtitle: "Manage vaccinations",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VaccinationRecordsScreen()),
                        ),
                      ),
                      _buildGridCard(
                        icon: Icons.search,
                        title: "Lost & Found",
                        subtitle: "Report or search pets",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LostAndFoundScreen()),
                        ),
                      ),
                      _buildGridCard(
                        icon: Icons.favorite_border,
                        title: "Memorials",
                        subtitle: "Tributes & memories",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MemorialsScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// NOTIFICATION DROPDOWN
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
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.info_outline,
                                        size: 18, color: Color(0xFF5A4FCF)),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(note)),
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

  /// Grid Card Widget
  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
            Icon(icon, size: 36, color: const Color(0xFF5A4FCF)),
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
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
