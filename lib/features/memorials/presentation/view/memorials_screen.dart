import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_cubit.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_state.dart';

class MemorialsScreen extends StatefulWidget {
  const MemorialsScreen({super.key});

  @override
  State<MemorialsScreen> createState() => _MemorialsScreenState();
}

class _MemorialsScreenState extends State<MemorialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  DateTime? dateOfPassing;
  File? pickedImage;
  String? imageUrl;
  String? editingId;

  @override
  void initState() {
    super.initState();
    context.read<MemorialCubit>().loadMemorials();
  }

  void resetForm() {
    nameController.clear();
    messageController.clear();
    dateOfPassing = null;
    pickedImage = null;
    imageUrl = null;
    editingId = null;
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => pickedImage = File(picked.path));
      try {
        final url = await context.read<MemorialCubit>().uploadImage(picked.path);
        setState(() => imageUrl = url);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed")),
        );
      }
    }
  }

  void handleSubmit() {
    if (!_formKey.currentState!.validate() || dateOfPassing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the form")),
      );
      return;
    }

    final entry = MemorialEntity(
      id: editingId ?? '',
      petName: nameController.text.trim(),
      message: messageController.text.trim(),
      dateOfPassing: DateFormat('yyyy-MM-dd').format(dateOfPassing!),
      imageUrl: imageUrl ?? '',
    );

    if (editingId == null) {
      context.read<MemorialCubit>().addMemorial(entry);
    } else {
      context.read<MemorialCubit>().updateMemorial(editingId!, entry);
    }

    resetForm();
  }

  void handleEdit(MemorialEntity e) {
    setState(() {
      editingId = e.id;
      nameController.text = e.petName;
      messageController.text = e.message;
      dateOfPassing = DateTime.tryParse(e.dateOfPassing);
      imageUrl = e.imageUrl;
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
      body: BlocBuilder<MemorialCubit, MemorialState>(
        builder: (context, state) {
          if (state is MemorialLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemorialLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Form Section
                  buildForm(),
                  const SizedBox(height: 24),

                  /// List Section
                  ...state.memorials.map(buildCard).toList(),
                ],
              ),
            );
          } else if (state is MemorialError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else {
            return const Center(child: Text("Unexpected state"));
          }
        },
      ),
    );
  }

  Widget buildForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Pet's Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(labelText: "Message (optional)"),
                maxLines: 3,
              ),
              Row(
                children: [
                  const Text("Date of Passing:"),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: dateOfPassing ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => dateOfPassing = date);
                    },
                    child: Text(
                      dateOfPassing == null
                          ? "Select Date"
                          : DateFormat("yyyy-MM-dd").format(dateOfPassing!),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Pick Photo"),
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  ),
                  const SizedBox(width: 12),
                  imageUrl != null
                      ? const Text("Photo uploaded ✅", style: TextStyle(color: Colors.green))
                      : const Text("No image uploaded", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleSubmit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                child: Text(editingId == null ? "Add Memorial" : "Update Memorial"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(MemorialEntity m) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (m.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  m.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              m.petName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            if (m.message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '"${m.message}"',
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
                ),
              ),
            Text("Passed on: ${m.dateOfPassing}", style: const TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => handleEdit(m),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => context.read<MemorialCubit>().deleteMemorial(m.id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
