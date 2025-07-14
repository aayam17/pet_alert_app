import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MemorialsScreen extends StatefulWidget {
  const MemorialsScreen({super.key});

  @override
  State<MemorialsScreen> createState() => _MemorialsScreenState();
}

class _MemorialsScreenState extends State<MemorialsScreen> {
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> memorials = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  DateTime? dateOfPassing;
  File? pickedImage;

  String? editingId;

  @override
  void initState() {
    super.initState();
    fetchMemorials();
  }

  /// Replace with your real backend call
  void fetchMemorials() {
    setState(() {
      memorials = [
        {
          "_id": "1",
          "petName": "Buddy",
          "message": "You were my sunshine every day.",
          "dateOfPassing": "2025-07-08",
          "imagePath": null,
        },
        {
          "_id": "2",
          "petName": "Luna",
          "message": "Forever in my heart.",
          "dateOfPassing": "2025-06-20",
          "imagePath": null,
        },
      ];
    });
  }

  void resetForm() {
    nameController.clear();
    messageController.clear();
    dateOfPassing = null;
    pickedImage = null;
    editingId = null;
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        pickedImage = File(picked.path);
      });
    }
  }

  void handleSubmit() {
    if (nameController.text.trim().isEmpty || dateOfPassing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter pet name and date.")),
      );
      return;
    }

    final newMemorial = {
      "_id": editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      "petName": nameController.text.trim(),
      "message": messageController.text.trim(),
      "dateOfPassing": DateFormat('yyyy-MM-dd').format(dateOfPassing!),
      "imagePath": pickedImage?.path,
    };

    setState(() {
      if (editingId != null) {
        memorials = memorials.map((m) {
          if (m["_id"] == editingId) return newMemorial;
          return m;
        }).toList();
      } else {
        memorials.add(newMemorial);
      }
      resetForm();
    });
  }

  void handleEdit(Map<String, dynamic> memorial) {
    setState(() {
      editingId = memorial["_id"];
      nameController.text = memorial["petName"];
      messageController.text = memorial["message"];
      dateOfPassing = DateTime.parse(memorial["dateOfPassing"]);
      pickedImage = memorial["imagePath"] != null
          ? File(memorial["imagePath"])
          : null;
    });
  }

  void handleDelete(String id) {
    setState(() {
      memorials.removeWhere((m) => m["_id"] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text("Memorial Tribute Board"),
        backgroundColor: Colors.pink,
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
                    /// Pet Name
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Pet's Name",
                      ),
                    ),

                    /// Message
                    TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        labelText: "Your Message (Optional)",
                      ),
                      maxLines: 3,
                    ),

                    /// Date of Passing
                    Row(
                      children: [
                        const Text("Date of Passing:"),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  dateOfPassing ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                dateOfPassing = date;
                              });
                            }
                          },
                          child: Text(
                            dateOfPassing == null
                                ? "Select Date"
                                : DateFormat("yyyy-MM-dd")
                                    .format(dateOfPassing!),
                          ),
                        )
                      ],
                    ),

                    /// Image Picker
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Select Photo"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                        ),
                        const SizedBox(width: 12),
                        pickedImage != null
                            ? Text(
                                "Photo selected",
                                style: const TextStyle(
                                    color: Colors.green),
                              )
                            : const Text(
                                "No photo selected",
                                style: TextStyle(color: Colors.grey),
                              ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      onPressed: handleSubmit,
                      child: Text(editingId != null
                          ? "Update Memorial"
                          : "Add Memorial"),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// MEMORIAL BOARD
            if (memorials.isNotEmpty)
              Column(
                children: memorials.map((memorial) {
                  return Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          /// Pet Image
                          if (memorial["imagePath"] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(memorial["imagePath"]),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 8),

                          /// Pet Name
                          Text(
                            memorial["petName"],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),

                          /// Message
                          if (memorial["message"].isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "\"${memorial["message"]}\"",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                          /// Date
                          Text(
                            "Passed on: ${memorial["dateOfPassing"]}",
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 8),

                          /// Buttons
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: () => handleEdit(memorial),
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue),
                                label: const Text("Edit"),
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    handleDelete(memorial["_id"]),
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                label: const Text("Delete"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              const Text(
                "No memorials added yet. Share your tribute.",
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
