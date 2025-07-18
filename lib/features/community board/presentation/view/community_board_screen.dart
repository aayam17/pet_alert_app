import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/community board/presentation/view_model/community_board_cubit.dart';
import 'package:pet_alert_app/features/community board/presentation/view_model/community_board_state.dart';

class CommunityBoardScreen extends StatefulWidget {
  const CommunityBoardScreen({super.key});

  @override
  State<CommunityBoardScreen> createState() => _CommunityBoardScreenState();
}

class _CommunityBoardScreenState extends State<CommunityBoardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityBoardCubit>().loadBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Board", style: TextStyle(color: Color(0xFF5A4FCF))),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF5A4FCF)),
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: BlocBuilder<CommunityBoardCubit, CommunityBoardState>(
        builder: (context, state) {
          if (state is CommunityBoardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CommunityBoardLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text("🐾 Lost & Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...state.lostFound.map(_buildLostCard),
                const SizedBox(height: 30),
                const Text("🕊️ Memorial Tributes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...state.memorials.map(_buildMemorialCard),
              ],
            );
          } else if (state is CommunityBoardError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildLostCard(lost) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(lost.description),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 ${lost.location}"),
            Text("📅 ${lost.date}   ⏰ ${lost.time}"),
            Text("☎️ Contact: ${lost.contactInfo}"),
            Text("Status: ${lost.type.toUpperCase()}"),
          ],
        ),
      ),
    );
  }

  Widget _buildMemorialCard(memorial) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: memorial.imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(memorial.imageUrl, height: 50, width: 50, fit: BoxFit.cover),
              )
            : null,
        title: Text(memorial.petName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🕯️ ${memorial.message}"),
            Text("📅 Passed on: ${memorial.dateOfPassing}"),
          ],
        ),
      ),
    );
  }
}
