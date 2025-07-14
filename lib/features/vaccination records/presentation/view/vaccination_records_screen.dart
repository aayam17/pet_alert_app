import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VaccinationRecordsScreen extends StatefulWidget {
  const VaccinationRecordsScreen({super.key});

  @override
  State<VaccinationRecordsScreen> createState() => _VaccinationRecordsScreenState();
}

class _VaccinationRecordsScreenState extends State<VaccinationRecordsScreen> {
  List<Map<String, dynamic>> records = [];

  DateTime? selectedDate;
  TextEditingController vaccineController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String? editingId;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  /// Replace this with your actual API calls
  Future<void> fetchRecords() async {
    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      records = [
        {
          '_id': '1',
          'date': '2025-06-20',
          'vaccine': 'Rabies',
          'notes': 'Booster needed in 1 year',
        },
        {
          '_id': '2',
          'date': '2025-07-10',
          'vaccine': 'Parvovirus',
          'notes': '',
        },
      ];
    });
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

    final formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate!);

    final newRecord = {
      '_id': editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'date': formattedDate,
      'vaccine': vaccineController.text.trim(),
      'notes': notesController.text.trim(),
    };

    setState(() {
      if (editingId != null) {
        // Update
        records = records.map((rec) {
          if (rec['_id'] == editingId) {
            return newRecord;
          }
          return rec;
        }).toList();
      } else {
        // Add new
        records.add(newRecord);
      }
      resetForm();
    });
  }

  void handleEdit(Map<String, dynamic> record) {
    setState(() {
      editingId = record['_id'];
      selectedDate = DateTime.parse(record['date']);
      vaccineController.text = record['vaccine'];
      notesController.text = record['notes'];
    });
  }

  void handleDelete(String id) {
    setState(() {
      records.removeWhere((rec) => rec['_id'] == id);
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
            /// Form
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
                        ),
                      ],
                    ),

                    /// Vaccine Name
                    TextFormField(
                      controller: vaccineController,
                      decoration: const InputDecoration(
                        labelText: "Vaccine Name",
                      ),
                    ),

                    /// Notes
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: "Notes",
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: handleSubmit,
                      child: Text(editingId != null
                          ? 'Update Record'
                          : 'Add Record'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Records List
            records.isNotEmpty
                ? Column(
                    children: records.map(
                      (record) {
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${record['date']} - ${record['vaccine']}'),
                            subtitle: record['notes'].isNotEmpty
                                ? Text('Notes: ${record['notes']}')
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => handleEdit(record),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      handleDelete(record['_id']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )
                : const Text("No vaccination records added."),
          ],
        ),
      ),
    );
  }
}
