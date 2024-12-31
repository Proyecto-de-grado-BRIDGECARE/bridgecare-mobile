import 'package:flutter/material.dart';
import 'package:bridgecare/features/home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
        const AssetImage('assets/images/bridgecare_logo.png'), context);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 5)); // simulate network call
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );

      // If error occurred:
      // setState(() => _isLoading = false);
      // show an error, etc.
    }
  }

  OutlineInputBorder _normalBorder(Color color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(1),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0E0147),
        body: Column(
          children: [
            Expanded(
              flex: 65,
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Image.asset(
                    'assets/images/bridgecare_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 35,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username
                      TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 1.0,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          hintText: 'Usuario',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: _normalBorder(Colors.grey.shade400, 1),
                          focusedBorder:
                              _normalBorder(const Color(0xFF676767), 1.5),
                          errorBorder: _normalBorder(Colors.red, 1),
                          focusedErrorBorder: _normalBorder(Colors.red, 1.5),
                          errorStyle:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su usuario';
                          }
                          if (value.contains(' ')) {
                            return 'Por favor ingrese un usuario válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 1.0,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          hintText: 'Contraseña',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: _normalBorder(Colors.grey.shade400, 1),
                          focusedBorder: _normalBorder(Colors.black, 1.5),
                          errorBorder: _normalBorder(Colors.red, 1),
                          focusedErrorBorder: _normalBorder(Colors.red, 1.5),
                          errorStyle:
                              const TextStyle(fontSize: 12, color: Colors.red),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            disabledBackgroundColor: const Color(0xFFFFC107),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
