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
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Frequently Asked Questions",
          style: TextStyle(
            color: Color(0xFF4B3F72),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4B3F72)),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isOpen = activeIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              title: Text(
                faq["question"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              subtitle: isOpen
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        faq["answer"]!,
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    )
                  : null,
              trailing: Icon(
                isOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: const Color(0xFF4B3F72),
              ),
              onTap: () => toggleFAQ(index),
            ),
          );
        },
      ),
    );
  }
}
