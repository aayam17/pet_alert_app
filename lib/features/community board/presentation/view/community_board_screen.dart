import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/community board/presentation/view_model/community_board_cubit.dart';
import 'package:pet_alert_app/features/community board/presentation/view_model/community_board_state.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityBoardScreen extends StatefulWidget {
  const CommunityBoardScreen({super.key});

  @override
  State<CommunityBoardScreen> createState() => _CommunityBoardScreenState();
}

class _CommunityBoardScreenState extends State<CommunityBoardScreen>
    with SingleTickerProviderStateMixin {
  String filter = 'All';
  String sortOrder = 'Newest';
  String searchQuery = '';
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    context.read<CommunityBoardCubit>().loadBoard();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  bool isNewEntry(String date) {
    final entryDate = DateTime.tryParse(date);
    if (entryDate == null) return false;
    return DateTime.now().difference(entryDate).inHours <= 48;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(
        bodyColor: isDark ? Colors.white : Colors.black,
        displayColor: isDark ? Colors.white : Colors.black,
      ),
    );

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF5A4FCF)),
        title: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [Colors.deepPurple, Colors.blueAccent],
                  begin: Alignment(-1 + 2 * _gradientController.value, -1),
                  end: Alignment(1 - 2 * _gradientController.value, 1),
                ).createShader(bounds);
              },
              child: Text(
                "Community Board",
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<CommunityBoardCubit, CommunityBoardState>(
        builder: (context, state) {
          if (state is CommunityBoardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CommunityBoardLoaded) {
            final filteredLost = state.lostFound.where((e) {
              final matchesFilter = filter == 'All' || e.type.toLowerCase() == filter.toLowerCase();
              final matchesSearch = searchQuery.isEmpty || e.description.toLowerCase().contains(searchQuery.toLowerCase());
              return matchesFilter && matchesSearch;
            }).toList();

            if (sortOrder == 'Oldest') {
              filteredLost.sort((a, b) => a.date.compareTo(b.date));
            } else {
              filteredLost.sort((a, b) => b.date.compareTo(a.date));
            }

            final filteredMemorials = state.memorials.where((m) =>
              searchQuery.isEmpty ||
              m.petName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              m.message.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// 🔍 Filters & Search
                Row(
                  children: [
                    DropdownButton<String>(
                      value: filter,
                      onChanged: (value) => setState(() => filter = value!),
                      items: ['All', 'Lost', 'Found']
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: sortOrder,
                      onChanged: (value) => setState(() => sortOrder = value!),
                      items: ['Newest', 'Oldest']
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),

                /// 🐾 Lost & Found Section
                AnimatedBuilder(
                  animation: _gradientController,
                  builder: (_, __) => ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: const [Colors.purple, Colors.teal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      "🐾 Lost & Found (${filteredLost.length})",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...filteredLost.map((e) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildLostCard(e, isDark, textTheme),
                    )),
                const SizedBox(height: 30),

                /// 🕊️ Memorial Section
                AnimatedBuilder(
                  animation: _gradientController,
                  builder: (_, __) => ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: const [Colors.pink, Colors.cyan],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      "🕊️ Memorial Tributes (${filteredMemorials.length})",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...filteredMemorials.map((m) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildMemorialCard(m, isDark, textTheme),
                    )),
              ],
            );
          } else if (state is CommunityBoardError) {
            return Center(child: Text(state.message, style: textTheme.bodyLarge));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildLostCard(lost, bool isDark, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Description + "🆕"
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  lost.description,
                  style: textTheme.titleMedium,
                ),
              ),
              if (isNewEntry(lost.date))
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.orangeAccent, Colors.yellow],
                    ).createShader(bounds),
                    child: const Text("🆕",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text("📍 ${lost.location}", style: textTheme.bodyMedium),
          Text("📅 ${lost.date}   ⏰ ${lost.time}", style: textTheme.bodyMedium),
          Text("☎️ Contact: ${lost.contactInfo}", style: textTheme.bodyMedium),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: lost.type.toLowerCase() == 'lost' ? Colors.red[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              lost.type.toUpperCase(),
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemorialCard(memorial, bool isDark, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (memorial.imageUrl.isNotEmpty)
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: Image.network(memorial.imageUrl, fit: BoxFit.contain),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(memorial.imageUrl, height: 60, width: 60, fit: BoxFit.cover),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(memorial.petName, style: textTheme.titleMedium),
                if (memorial.message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('"${memorial.message}"',
                        style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                  ),
                Text("📅 Passed on: ${memorial.dateOfPassing}", style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
