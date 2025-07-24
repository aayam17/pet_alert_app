import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import '../view_model/vet_appointment_cubit.dart';
import '../view_model/vet_appointment_state.dart';

class VetAppointmentsScreen extends StatefulWidget {
  const VetAppointmentsScreen({super.key});

  @override
  State<VetAppointmentsScreen> createState() => _VetAppointmentsScreenState();
}

class _VetAppointmentsScreenState extends State<VetAppointmentsScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController notesController = TextEditingController();
  String? editingId;

  @override
  void initState() {
    super.initState();
    context.read<VetAppointmentCubit>().loadAppointments();
  }

  void resetForm() {
    selectedDate = null;
    selectedTime = null;
    notesController.clear();
    editingId = null;
  }

  void handleSubmit() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time.")),
      );
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final formattedTime =
        "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

    final appt = AppointmentEntity(
      id: editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: formattedDate,
      time: formattedTime,
      notes: notesController.text,
    );

    if (editingId != null) {
      context.read<VetAppointmentCubit>().updateAppointment(editingId!, appt);
    } else {
      context.read<VetAppointmentCubit>().addAppointment(appt);
    }

    resetForm();
  }

  void handleEdit(AppointmentEntity appt) {
    setState(() {
      editingId = appt.id;
      selectedDate = DateTime.parse(appt.date);
      selectedTime = _parseTime(appt.time);
      notesController.text = appt.notes;
    });
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final format = DateFormat.Hm();
      final dateTime = format.parse(timeString);
      return TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      return TimeOfDay.now();
    }
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
        title: Text('Vet Appointments',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          children: [
            _formCard(textTheme),
            const SizedBox(height: 24),
            BlocBuilder<VetAppointmentCubit, VetAppointmentState>(
              builder: (context, state) {
                if (state is VetAppointmentLoading) {
                  return const CircularProgressIndicator();
                } else if (state is VetAppointmentLoaded) {
                  if (state.appointments.isEmpty) {
                    return Text("No appointments yet.", style: textTheme.bodyMedium);
                  }
                  return Column(
                    children: state.appointments.map((appt) {
                      return _appointmentCard(appt, textTheme);
                    }).toList(),
                  );
                } else if (state is VetAppointmentError) {
                  return Text(state.message, style: textTheme.bodyMedium);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100], // 🩺 updated background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          _buildFormRow(label: 'Date', child: _datePickerButton(textTheme)),
          const SizedBox(height: 10),
          _buildFormRow(label: 'Time', child: _timePickerButton(textTheme)),
          const SizedBox(height: 10),
          TextFormField(
            controller: notesController,
            decoration: InputDecoration(
              labelText: 'Notes',
              labelStyle: textTheme.bodyMedium,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 🔘 updated to black
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: handleSubmit,
              child: Text(
                editingId != null ? 'Update Appointment' : 'Add Appointment',
                style: textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentCard(AppointmentEntity appt, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // 📋 updated background
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
          child: Icon(Icons.person, color: Colors.white, size: 24),
        ),
        title: Text('${appt.date} • ${appt.time}', style: textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(appt.notes, style: textTheme.bodyMedium),
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_note_outlined, color: Colors.teal),
              tooltip: 'Edit Appointment',
              onPressed: () => handleEdit(appt),
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
              tooltip: 'Delete Appointment',
              onPressed: () {
                context.read<VetAppointmentCubit>().deleteAppointment(appt.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormRow({required String label, required Widget child}) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text('$label:', style: GoogleFonts.poppins(fontSize: 16))),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }

  Widget _datePickerButton(TextTheme textTheme) {
    return TextButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) setState(() => selectedDate = date);
      },
      child: Text(
        selectedDate == null
            ? 'Select date'
            : DateFormat('yyyy-MM-dd').format(selectedDate!),
        style: textTheme.bodyLarge?.copyWith(color: Colors.black),
      ),
    );
  }

  Widget _timePickerButton(TextTheme textTheme) {
    return TextButton(
      onPressed: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (time != null) setState(() => selectedTime = time);
      },
      child: Text(
        selectedTime == null
            ? 'Select time'
            : "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
        style: textTheme.bodyLarge?.copyWith(color: Colors.black),
      ),
    );
  }
}
