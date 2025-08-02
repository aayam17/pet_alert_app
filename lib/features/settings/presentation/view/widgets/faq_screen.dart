import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      "answer": "Navigate to 'Pet Profiles' and click 'Add New Pet'."
    },
    {
      "question": "Can I track vaccination records?",
      "answer": "Yes! Go to each pet profile and update their records."
    },
    {
      "question": "How to book a vet appointment?",
      "answer": "Open 'Vet Appointments', choose your vet and time slot."
    },
    {
      "question": "What if I lose my pet?",
      "answer": "Use the 'Lost & Found Board' to report or find pets."
    },
  ];

  void toggleFAQ(int index) {
    setState(() => activeIndex = activeIndex == index ? null : index);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(bodyColor: Colors.black),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF4B3F72), Color(0xFF00B4DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "FAQs",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final isOpen = activeIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                faqs[index]["question"]!,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: isOpen
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        faqs[index]["answer"]!,
                        style: const TextStyle(color: Colors.black54, height: 1.4),
                      ),
                    )
                  : null,
              trailing: Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
