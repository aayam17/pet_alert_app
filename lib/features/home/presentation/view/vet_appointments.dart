import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VetAppointmentsScreen extends StatefulWidget {
  const VetAppointmentsScreen({super.key});

  @override
  State<VetAppointmentsScreen> createState() => _VetAppointmentsScreenState();
}

class _VetAppointmentsScreenState extends State<VetAppointmentsScreen> {
  List<Map<String, dynamic>> appointments = [];

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController notesController = TextEditingController();

  String? editingId;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  /// Replace this with your actual API calls
  Future<void> fetchAppointments() async {
    // Simulate fetch
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      appointments = [
        {
          '_id': '1',
          'date': '2025-07-12',
          'time': '10:30 AM',
          'notes': 'Annual checkup'
        },
        {
          '_id': '2',
          'date': '2025-07-15',
          'time': '2:00 PM',
          'notes': 'Vaccination'
        },
      ];
    });
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

    final formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate!);

    final formattedTime =
        selectedTime!.format(context);

    final newAppointment = {
      '_id': editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'date': formattedDate,
      'time': formattedTime,
      'notes': notesController.text,
    };

    setState(() {
      if (editingId != null) {
        // Update existing
        appointments = appointments.map((appt) {
          if (appt['_id'] == editingId) {
            return newAppointment;
          }
          return appt;
        }).toList();
      } else {
        // Add new
        appointments.add(newAppointment);
      }
      resetForm();
    });
  }

  void handleEdit(Map<String, dynamic> appt) {
    setState(() {
      editingId = appt['_id'];
      selectedDate = DateTime.parse(appt['date']);
      selectedTime = _parseTime(appt['time']);
      notesController.text = appt['notes'];
    });
  }

  void handleDelete(String id) {
    setState(() {
      appointments.removeWhere((appt) => appt['_id'] == id);
    });
  }

  TimeOfDay _parseTime(String timeString) {
    final format = DateFormat.jm(); // e.g. 2:00 PM
    final dateTime = format.parse(timeString);
    return TimeOfDay.fromDateTime(dateTime);
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
                    /// Date picker
                    Row(
                      children: [
                        const Text('Date:'),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  selectedDate ?? DateTime.now(),
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
                                : DateFormat('yyyy-MM-dd')
                                    .format(selectedDate!),
                          ),
                        )
                      ],
                    ),

                    /// Time picker
                    Row(
                      children: [
                        const Text('Time:'),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime:
                                  selectedTime ?? TimeOfDay.now(),
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
                                : selectedTime!.format(context),
                          ),
                        )
                      ],
                    ),

                    /// Notes
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                      ),
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

            /// Appointments List
            ...appointments.map(
              (appt) => Card(
                child: ListTile(
                  title: Text(
                      'Date: ${appt['date']}  |  Time: ${appt['time']}'),
                  subtitle: Text(appt['notes']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => handleEdit(appt),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => handleDelete(appt['_id']),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
