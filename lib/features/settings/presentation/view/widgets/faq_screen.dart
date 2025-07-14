import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? activeIndex;

  final List<Map<String, String>> faqs = [
    {
      "question": "How do I create a pet profile?",
      "answer":
          "To create a pet profile, navigate to the 'Pet Profiles' section and click the 'Add New Pet' button. Fill in the details and save.",
    },
    {
      "question": "Can I track my pet's vaccination records?",
      "answer":
          "Yes! You can add, edit, and view vaccination records under each pet's profile to stay up-to-date.",
    },
    {
      "question": "How do I book a vet appointment?",
      "answer":
          "Visit the 'Vet Appointments' page, select your preferred vet and time slot, and confirm your booking.",
    },
    {
      "question": "What if I lose my pet?",
      "answer":
          "Use the 'Lost & Found Board' to report lost pets or check if someone has found a pet matching your description.",
    },
  ];

  void toggleFAQ(int index) {
    setState(() {
      activeIndex = activeIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("FAQ"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isOpen = activeIndex == index;
          return Card(
            child: ListTile(
              title: Text(
                faq["question"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: isOpen
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(faq["answer"]!),
                    )
                  : null,
              trailing: Icon(isOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onTap: () => toggleFAQ(index),
            ),
          );
        },
      ),
    );
  }
}
