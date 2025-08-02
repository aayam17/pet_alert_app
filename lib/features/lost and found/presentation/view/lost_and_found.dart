import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pet_alert_app/features/lost%20and%20found/domian/entity/lost_and_found_entity.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_cubit.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_state.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String type = "Lost";
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? editingId;

  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    context.read<LostAndFoundCubit>().loadEntries();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  void resetForm() {
    type = "Lost";
    descriptionController.clear();
    locationController.clear();
    selectedDate = null;
    selectedTime = null;
    editingId = null;
  }

  void submitForm() {
    if (!_formKey.currentState!.validate() || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final formattedTime = selectedTime!.format(context);

    final entry = LostAndFoundEntity(
      id: editingId ?? '',
      type: type,
      description: descriptionController.text.trim(),
      location: locationController.text.trim(),
      date: formattedDate,
      time: formattedTime,
      contactInfo: "temp@example.com",
    );

    if (editingId == null) {
      context.read<LostAndFoundCubit>().addEntry(entry);
    } else {
      context.read<LostAndFoundCubit>().updateEntry(editingId!, entry);
    }

    resetForm();
  }

  void populateForm(LostAndFoundEntity entry) {
    setState(() {
      editingId = entry.id;
      type = entry.type;
      descriptionController.text = entry.description;
      locationController.text = entry.location;
      selectedDate = DateTime.tryParse(entry.date);
      selectedTime = _parseTime(entry.time);
    });
  }

  TimeOfDay _parseTime(String timeString) {
    final format = DateFormat.jm();
    final dt = format.parse(timeString);
    return TimeOfDay.fromDateTime(dt);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) => ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: const [Colors.deepPurple, Colors.cyan],
              begin: Alignment(-1 + 2 * _gradientController.value, -1),
              end: Alignment(1 - 2 * _gradientController.value, 1),
            ).createShader(bounds),
            child: Text(
              "Lost and Found Board",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<LostAndFoundCubit, LostAndFoundState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// FORM CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD1C4E9), Color(0xFFB2EBF2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: type,
                          decoration: const InputDecoration(labelText: "Type"),
                          items: ["Lost", "Found"]
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (value) => setState(() => type = value!),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(labelText: "Description"),
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(labelText: "Location"),
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Date:"),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) setState(() => selectedDate = picked);
                              },
                              child: Text(
                                selectedDate == null
                                    ? "Select date"
                                    : DateFormat("yyyy-MM-dd").format(selectedDate!),
                                style: textTheme.bodyLarge?.copyWith(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Time:"),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime ?? TimeOfDay.now(),
                                );
                                if (picked != null) setState(() => selectedTime = picked);
                              },
                              child: Text(
                                selectedTime == null
                                    ? "Select time"
                                    : selectedTime!.format(context),
                                style: textTheme.bodyLarge?.copyWith(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4B3F72), Color(0xFF00B4DB)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: submitForm,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              editingId == null ? "Add Entry" : "Update Entry",
                              style: textTheme.labelLarge?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (state is LostAndFoundLoading)
                  const CircularProgressIndicator()
                else if (state is LostAndFoundLoaded)
                  Column(
                    children: state.entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: entry.type.toLowerCase() == 'lost'
                                      ? Colors.red[100]
                                      : Colors.green[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  entry.type.toUpperCase(),
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(entry.description,
                                    style: textTheme.titleMedium?.copyWith(color: Colors.black)),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u{1F4CD} ${entry.location}", style: textTheme.bodyMedium),
                                Text("\u{1F552} ${entry.date} at ${entry.time}", style: textTheme.bodySmall),
                                Text("\u{1F4DE} ${entry.contactInfo}", style: textTheme.bodySmall),
                              ],
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_note_outlined, color: Colors.teal),
                                tooltip: 'Edit Entry',
                                onPressed: () => populateForm(entry),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                                tooltip: 'Delete Entry',
                                onPressed: () => context.read<LostAndFoundCubit>().deleteEntry(entry.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else if (state is LostAndFoundError)
                  Text(state.message, style: const TextStyle(color: Colors.red))
                else
                  const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}