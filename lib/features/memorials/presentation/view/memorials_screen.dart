import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Memorial Tribute Board", style: textTheme.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
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
                  buildForm(textTheme),
                  const SizedBox(height: 24),
                  ...state.memorials.map((m) => buildCard(m, textTheme)),
                ],
              ),
            );
          } else if (state is MemorialError) {
            return Center(
              child: Text(state.message,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.red)),
            );
          } else {
            return const Center(child: Text("Unexpected state"));
          }
        },
      ),
    );
  }

  Widget buildForm(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Pet's Name"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: messageController,
              decoration: const InputDecoration(labelText: "Message (optional)"),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 120, child: Text("Date of Passing:", style: textTheme.bodyLarge)),
                Expanded(
                  child: TextButton(
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
                      style: textTheme.bodyLarge?.copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text("Pick Photo", style: TextStyle(color: Colors.white)),
                  onPressed: pickImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    imageUrl != null ? "Photo uploaded" : "No image uploaded",
                    style: TextStyle(
                      color: imageUrl != null ? Colors.green : Colors.redAccent,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleSubmit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text(
                  editingId == null ? "Add Memorial" : "Update Memorial",
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(MemorialEntity m, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (m.message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '"${m.message}"',
                  style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            Text("Passed on: ${m.dateOfPassing}", style: textTheme.bodySmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_note_outlined, color: Colors.teal),
                  tooltip: "Edit Memorial",
                  onPressed: () => handleEdit(m),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                  tooltip: "Delete Memorial",
                  onPressed: () => context.read<MemorialCubit>().deleteMemorial(m.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
