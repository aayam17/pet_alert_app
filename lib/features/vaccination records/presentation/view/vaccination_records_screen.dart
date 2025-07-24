import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination%20records/presentation/view_model/vaccination_cubit.dart';
import 'package:pet_alert_app/features/vaccination%20records/presentation/view_model/vaccination_state.dart';

class VaccinationRecordsScreen extends StatefulWidget {
  const VaccinationRecordsScreen({super.key});

  @override
  State<VaccinationRecordsScreen> createState() => _VaccinationRecordsScreenState();
}

class _VaccinationRecordsScreenState extends State<VaccinationRecordsScreen> {
  DateTime? selectedDate;
  TextEditingController vaccineController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String? editingId;

  @override
  void initState() {
    super.initState();
    context.read<VaccinationCubit>().loadRecords();
  }

  void resetForm() {
    selectedDate = null;
    vaccineController.clear();
    notesController.clear();
    editingId = null;
  }

  void handleSubmit() {
    if (selectedDate == null || vaccineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a vaccine name and date.")),
      );
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

    final record = VaccinationRecordEntity(
      id: editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: formattedDate,
      vaccine: vaccineController.text.trim(),
      notes: notesController.text.trim(),
    );

    if (editingId != null) {
      context.read<VaccinationCubit>().updateRecord(editingId!, record);
    } else {
      context.read<VaccinationCubit>().addRecord(record);
    }

    resetForm();
  }

  void handleEdit(VaccinationRecordEntity record) {
    setState(() {
      editingId = record.id;
      selectedDate = DateTime.parse(record.date);
      vaccineController.text = record.vaccine;
      notesController.text = record.notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Vaccination Records",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Form Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100], // updated form background
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Date Picker
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text("Date:", style: textTheme.bodyLarge),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          },
                          child: Text(
                            selectedDate == null
                                ? 'Select date'
                                : DateFormat('yyyy-MM-dd').format(selectedDate!),
                            style: textTheme.bodyLarge?.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// Vaccine Name
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: vaccineController,
                    decoration: InputDecoration(
                      labelText: "Vaccine Name",
                      labelStyle: textTheme.bodyMedium,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  /// Notes
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: "Notes",
                      labelStyle: textTheme.bodyMedium,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: handleSubmit,
                      child: Text(
                        editingId != null ? 'Update Record' : 'Add Record',
                        style: textTheme.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// List Section
            BlocBuilder<VaccinationCubit, VaccinationState>(
              builder: (context, state) {
                if (state is VaccinationLoading) {
                  return const CircularProgressIndicator();
                } else if (state is VaccinationLoaded) {
                  return state.records.isEmpty
                      ? Text("No vaccination records added.", style: textTheme.bodyMedium)
                      : Column(
                          children: state.records.map((record) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50], // updated card background
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.black,
                                  child: Icon(Icons.vaccines, color: Colors.white, size: 20),
                                ),
                                title: Text('${record.date} • ${record.vaccine}',
                                    style: textTheme.titleMedium),
                                subtitle: record.notes.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text('Notes: ${record.notes}',
                                            style: textTheme.bodyMedium),
                                      )
                                    : null,
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_note_outlined, color: Colors.teal),
                                      tooltip: 'Edit Record',
                                      onPressed: () => handleEdit(record),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                                      tooltip: 'Delete Record',
                                      onPressed: () {
                                        context.read<VaccinationCubit>().deleteRecord(record.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                } else if (state is VaccinationError) {
                  return Text(state.message,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.red));
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
