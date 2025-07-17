import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:pet_alert_app/features/lost%20and%20found/domian/entity/lost_and_found_entity.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_cubit.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_state.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  final _formKey = GlobalKey<FormState>();
  String type = "Lost";
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? editingId;

  @override
  void initState() {
    super.initState();
    context.read<LostAndFoundCubit>().loadEntries();
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
      contactInfo: "temp@example.com", // will be overridden by backend
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

  Color _getCardColor(String type) {
    return type == "Lost" ? Colors.red.shade100 : Colors.green.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text("Lost and Found Board"),
        backgroundColor: Colors.orange,
      ),
      body: BlocBuilder<LostAndFoundCubit, LostAndFoundState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// FORM
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(labelText: "Description"),
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                            maxLines: 3,
                          ),
                          TextFormField(
                            controller: locationController,
                            decoration: const InputDecoration(labelText: "Location"),
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                          ),
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
                                ),
                              )
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
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            onPressed: submitForm,
                            child: Text(editingId == null ? "Add Entry" : "Update Entry"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// STATE-BASED UI
                if (state is LostAndFoundLoading)
                  const CircularProgressIndicator()
                else if (state is LostAndFoundLoaded)
                  Column(
                    children: state.entries.map((entry) {
                      return Card(
                        color: _getCardColor(entry.type),
                        child: ListTile(
                          title: Text("[${entry.type}] ${entry.description}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location: ${entry.location}"),
                              Text("Date & Time: ${entry.date} at ${entry.time}"),
                              Text("Contact: ${entry.contactInfo}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => populateForm(entry),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
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
