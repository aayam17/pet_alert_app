import 'package:flutter/material.dart';
import 'package:pet_alert_app/features/home/presentation/view/lost_and_found.dart';
import 'package:pet_alert_app/features/home/presentation/view/memorials_screen.dart';
import 'package:pet_alert_app/features/home/presentation/view/vaccination_records_screen.dart';
import 'package:pet_alert_app/features/home/presentation/view/vet_appointments.dart';
import 'package:pet_alert_app/features/home/presentation/view/widgets/dashboard_card.dart';
import 'package:pet_alert_app/features/home/presentation/view/widgets/pet_profile_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const PetProfileForm(),
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
                      builder: (_) =>
                          const VaccinationRecordsScreen()),
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
