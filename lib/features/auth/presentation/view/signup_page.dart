import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_alert_app/app/service_locator/service_locator.dart';
import 'package:pet_alert_app/features/auth/presentation/view/login_page.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_event.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_state.dart';
import 'widgets/terms_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms & Conditions')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(
            SignupSubmitted(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              context: context,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(bodyColor: Colors.black),
    );

    return BlocProvider(
      create: (_) => SignupBloc(signupUseCase: serviceLocator()),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup successful! Please log in.')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    AnimatedBuilder(
                      animation: _gradientController,
                      builder: (context, _) => ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: const [Color(0xFF4B3F72), Color(0xFF00B4DB)],
                          begin: Alignment(-1 + 2 * _gradientController.value, -1),
                          end: Alignment(1 - 2 * _gradientController.value, 1),
                        ).createShader(bounds),
                        child: Text(
                          "Join PetAlert!",
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    /// Name
                    TextFormField(
                      controller: _nameController,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter your full name' : null,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: borderRadius),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Email
                    TextFormField(
                      controller: _emailController,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter your email';
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        return regex.hasMatch(val) ? null : 'Enter a valid email';
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: borderRadius),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (val) =>
                          val == null || val.length < 6 ? 'Min 6 characters' : null,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        border: OutlineInputBorder(borderRadius: borderRadius),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Terms Agreement
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (val) =>
                              setState(() => _agreedToTerms = val ?? false),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(color: Colors.black),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const TermsPage(),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// Signup Button
                    BlocBuilder<SignupBloc, SignupState>(
                      builder: (context, state) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4B3F72), Color(0xFF00B4DB)],
                            ),
                            borderRadius: borderRadius,
                          ),
                          child: TextButton(
                            onPressed: state.isLoading ? null : () => _onSubmit(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: state.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
