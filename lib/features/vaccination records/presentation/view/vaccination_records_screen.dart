import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFE3FDFD),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Vaccination Records"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Form Section
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// Date Picker
                    Row(
                      children: [
                        const Text("Date:"),
                        const SizedBox(width: 16),
                        TextButton(
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
                          ),
                        ),
                      ],
                    ),

                    /// Vaccine Name
                    TextFormField(
                      controller: vaccineController,
                      decoration: const InputDecoration(labelText: "Vaccine Name"),
                    ),

                    /// Notes
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: "Notes"),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: handleSubmit,
                      child: Text(editingId != null ? 'Update Record' : 'Add Record'),
                    ),
                  ],
                ),
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
                      ? const Text("No vaccination records added.")
                      : Column(
                          children: state.records.map((record) {
                            return Card(
                              child: ListTile(
                                title: Text('${record.date} - ${record.vaccine}'),
                                subtitle: record.notes.isNotEmpty
                                    ? Text('Notes: ${record.notes}')
                                    : null,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => handleEdit(record),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
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
                  return Text(state.message, style: const TextStyle(color: Colors.red));
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
