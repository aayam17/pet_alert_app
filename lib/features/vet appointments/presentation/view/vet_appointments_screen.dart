import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    final formattedTime = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

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
      final format = DateFormat.Hm(); // 24-hour format: "13:20"
      final dateTime = format.parse(timeString);
      return TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      debugPrint("Failed to parse time: $timeString — $e");
      return TimeOfDay.now(); // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Vet Appointments'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Form
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Date:'),
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
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Time:'),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                selectedTime = time;
                              });
                            }
                          },
                          child: Text(
                            selectedTime == null
                                ? 'Select time'
                                : "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: handleSubmit,
                      child: Text(editingId != null
                          ? 'Update Appointment'
                          : 'Add Appointment'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Appointment List
            BlocBuilder<VetAppointmentCubit, VetAppointmentState>(
              builder: (context, state) {
                if (state is VetAppointmentLoading) {
                  return const CircularProgressIndicator();
                } else if (state is VetAppointmentLoaded) {
                  return Column(
                    children: state.appointments.map((appt) {
                      return Card(
                        child: ListTile(
                          title: Text('Date: ${appt.date}  |  Time: ${appt.time}'),
                          subtitle: Text(appt.notes),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => handleEdit(appt),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context
                                      .read<VetAppointmentCubit>()
                                      .deleteAppointment(appt.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is VetAppointmentError) {
                  return Text(state.message);
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
