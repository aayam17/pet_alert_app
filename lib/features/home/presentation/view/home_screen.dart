import 'package:flutter/material.dart';
import 'package:pet_alert_app/features/home/presentation/view/widgets/dashboard_card.dart';
import 'package:pet_alert_app/features/pet%20profile/presentation/view/pet_profile_form.dart';
import '../../../vet appointments/presentation/view/vet_appointments.dart';
import '../../../vaccination records/presentation/view/vaccination_records_screen.dart';
import '../../../lost and found/presentation/view/lost_and_found.dart';
import '../../../memorials/presentation/view/memorials_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPetProfileExpanded = false;

  void togglePetProfile() {
    setState(() {
      isPetProfileExpanded = !isPetProfileExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3FDFD),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Pet Profile collapsible header
            GestureDetector(
              onTap: togglePetProfile,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pet Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Icon(
                      isPetProfileExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            ),

            /// Expanded Pet Profile Form
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: const PetProfileForm(),
              crossFadeState: isPetProfileExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            const SizedBox(height: 20),

            /// "Our PetAlert service"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Our PetAlert service",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Dashboard cards
            DashboardCard(
              title: "Vet Appointments",
              subtitle: "Check upcoming vet visits",
              icon: Icons.local_hospital,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VetAppointmentsScreen()),
                );
              },
            ),
            DashboardCard(
              title: "Vaccination Records",
              subtitle: "View vaccination schedule",
              icon: Icons.vaccines,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VaccinationRecordsScreen()),
                );
              },
            ),
            DashboardCard(
              title: "Lost & Found",
              subtitle: "See lost and found posts",
              icon: Icons.search,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LostAndFoundScreen()),
                );
              },
            ),
            DashboardCard(
              title: "Memorials",
              subtitle: "Remember your beloved pets",
              icon: Icons.favorite,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MemorialsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
