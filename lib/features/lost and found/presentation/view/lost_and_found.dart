import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  List<Map<String, dynamic>> entries = [];

  String type = "Lost";
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? editingId;

  @override
  void initState() {
    super.initState();
    fetchEntries();
  }

  /// Replace this with your real API calls
  Future<void> fetchEntries() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      entries = [
        {
          "_id": "1",
          "type": "Lost",
          "description": "Brown dog missing since morning",
          "location": "Central Park",
          "date": "2025-07-10",
          "time": "10:30 AM",
          "contactInfo": "555-1234"
        },
        {
          "_id": "2",
          "type": "Found",
          "description": "Grey cat found near grocery store",
          "location": "Main Street",
          "date": "2025-07-11",
          "time": "3:15 PM",
          "contactInfo": "owner@example.com"
        },
      ];
    });
  }

  void resetForm() {
    type = "Lost";
    descriptionController.clear();
    locationController.clear();
    selectedDate = null;
    selectedTime = null;
    editingId = null;
  }

  void handleSubmit() {
    if (descriptionController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    final formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate!);
    final formattedTime = selectedTime!.format(context);

    final newEntry = {
      "_id": editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      "type": type,
      "description": descriptionController.text.trim(),
      "location": locationController.text.trim(),
      "date": formattedDate,
      "time": formattedTime,
      "contactInfo": "N/A"
    };

    setState(() {
      if (editingId != null) {
        entries = entries.map((e) {
          if (e["_id"] == editingId) return newEntry;
          return e;
        }).toList();
      } else {
        entries.add(newEntry);
      }
      resetForm();
    });
  }

  void handleEdit(Map<String, dynamic> entry) {
    setState(() {
      editingId = entry["_id"];
      type = entry["type"];
      descriptionController.text = entry["description"];
      locationController.text = entry["location"];
      selectedDate = DateTime.parse(entry["date"]);
      selectedTime = _parseTime(entry["time"]);
    });
  }

  void handleDelete(String id) {
    setState(() {
      entries.removeWhere((e) => e["_id"] == id);
    });
  }

  TimeOfDay _parseTime(String timeString) {
    final format = DateFormat.jm(); // e.g. 3:15 PM
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// FORM
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// Type dropdown
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration:
                          const InputDecoration(labelText: "Type"),
                      items: ["Lost", "Found"]
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            type = value;
                          });
                        }
                      },
                    ),

                    /// Description
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                    ),

                    /// Location
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: "Location",
                      ),
                    ),

                    /// Date picker
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
                                ? "Select date"
                                : DateFormat("yyyy-MM-dd")
                                    .format(selectedDate!),
                          ),
                        )
                      ],
                    ),

                    /// Time picker
                    Row(
                      children: [
                        const Text("Time:"),
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
                                ? "Select time"
                                : selectedTime!.format(context),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: handleSubmit,
                      child: Text(editingId != null
                          ? "Update Entry"
                          : "Add Entry"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ENTRIES LIST
            entries.isNotEmpty
                ? Column(
                    children: entries.map((entry) {
                      return Card(
                        color: _getCardColor(entry["type"]),
                        child: ListTile(
                          title: Text(
                              "[${entry["type"]}] ${entry["description"]}"),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("Location: ${entry["location"]}"),
                              Text(
                                  "Date & Time: ${entry["date"]} at ${entry["time"]}"),
                              Text("Contact: ${entry["contactInfo"]}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue),
                                onPressed: () =>
                                    handleEdit(entry),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () =>
                                    handleDelete(entry["_id"]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : const Text(
                    "No entries added yet.",
                    style: TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
