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

class _VaccinationRecordsScreenState extends State<VaccinationRecordsScreen>
    with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  TextEditingController vaccineController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String? editingId;

  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    context.read<VaccinationCubit>().loadRecords();
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
              "Vaccination Records",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                  ),
                ],
              ),
              child: Column(
                children: [
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: vaccineController,
                    decoration: InputDecoration(
                      labelText: "Vaccine Name",
                      labelStyle: textTheme.bodyMedium,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: "Notes",
                      labelStyle: textTheme.bodyMedium,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    maxLines: 3,
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
                      onPressed: handleSubmit,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.deepPurple,
                                  child: Icon(Icons.vaccines, color: Colors.white, size: 20),
                                ),
                                title: Text('${record.date} • ${record.vaccine}',
                                    style: textTheme.titleMedium?.copyWith(color: Colors.black)),
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
