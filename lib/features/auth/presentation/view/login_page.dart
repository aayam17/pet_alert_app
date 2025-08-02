import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_alert_app/app/service_locator/service_locator.dart';
import 'package:pet_alert_app/features/auth/presentation/view/signup_page.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_event.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_state.dart';
import '../../../home/presentation/view/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme.apply(bodyColor: Colors.black),
    );

    return BlocProvider(
      create: (_) => LoginBloc(loginUseCase: serviceLocator()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Dashboard()),
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

                    /// Animated Gradient App Name
                    AnimatedBuilder(
                      animation: _gradientController,
                      builder: (context, _) {
                        return ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: const [Color(0xFF4B3F72), Color(0xFF00B4DB)],
                            begin: Alignment(-1 + 2 * _gradientController.value, -1),
                            end: Alignment(1 - 2 * _gradientController.value, 1),
                          ).createShader(bounds),
                          child: Text(
                            "Welcome to PetAlert",
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    /// Email Field
                    TextFormField(
                      controller: _emailController,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter your email' : null,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: borderRadius),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (val) =>
                          val == null || val.length < 6 ? 'Enter min 6 characters' : null,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                        ),
                        border: OutlineInputBorder(borderRadius: borderRadius),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// Login Button
                    BlocBuilder<LoginBloc, LoginState>(
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
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginBloc>().add(
                                            LoginSubmitted(
                                              email: _emailController.text.trim(),
                                              password: _passwordController.text.trim(),
                                              context: context,
                                            ),
                                          );
                                    }
                                  },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: state.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    /// Signup Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupPage()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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
