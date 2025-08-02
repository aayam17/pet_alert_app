import 'package:flutter/material.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF4B3F72), size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.5,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) => ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: const [Color(0xFF4B3F72), Color(0xFF00B4DB)],
              begin: Alignment(-1 + 2 * _gradientController.value, -1),
              end: Alignment(1 - 2 * _gradientController.value, 1),
            ).createShader(bounds),
            child: const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to PetAlert.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFF4B3F72), thickness: 1.2),
              _buildSectionTitle('User Content and Accuracy'),
              _buildSectionText(
                'You are responsible for the information you provide about your pets, '
                'including profiles, medical records, vaccination history, and lost-and-found posts. '
                'Please ensure all details are accurate and truthful.',
              ),
              _buildSectionTitle('Privacy and Data Protection'),
              _buildSectionText(
                'We protect your personal and pet data in accordance with our Privacy Policy. '
                'Your information will not be shared with third parties without your consent except as required by law.',
              ),
              _buildSectionTitle('Use of Services'),
              _buildSectionText(
                'PetAlert provides tools to help manage pet care and facilitate community support. '
                'We do not guarantee outcomes related to lost pets, medical treatments, or vet recommendations.',
              ),
              _buildSectionTitle('Community Conduct'),
              _buildSectionText(
                'Users must act respectfully and lawfully when posting on community boards. '
                'Inappropriate content or misuse may result in removal of posts or account suspension.',
              ),
              _buildSectionTitle('Limitation of Liability'),
              _buildSectionText(
                'PetAlert is not liable for any damages arising from use of the app, including loss, injury, or misinformation. '
                'Use the app responsibly and consult professionals for medical or legal advice.',
              ),
              _buildSectionTitle('Updates to Terms'),
              _buildSectionText(
                'We may update these terms occasionally. Continued use of the app after changes indicates acceptance.',
              ),
              const SizedBox(height: 20),
              const Text(
                'For questions, please contact our support team.\n\n'
                'Thank you for trusting PetAlert with your pet care needs.',
                style: TextStyle(fontSize: 14.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
