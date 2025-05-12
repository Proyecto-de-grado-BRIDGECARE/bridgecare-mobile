import 'package:bridgecare/features/auth/domain/models/auth_model.dart';
import 'package:bridgecare/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bridgecare/core/providers/theme_provider.dart';

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
  late ThemeProvider themeProvider;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.setDarkMode();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final request = LoginRequest(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final token = await _authService.login(request);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (token != null) {
        // Obtener info del usuario
        final user = await _authService.getUser();

        if (user != null) {
          themeProvider.setLightMode();

          switch (user.tipoUsuario) {
            case 0:
              Navigator.pushReplacementNamed(context, '/homeMunicipal');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/homeAdmin');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          _showError("Error obteniendo datos del usuario.");
        }
      } else {
        _showError("Credenciales inválidas.");
      }
    }
  }


  OutlineInputBorder _normalBorder(Color color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(10),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo electrónico';
    }
    // Basic email validation pattern
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su contraseña';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(
          context,
        ).unfocus(); // Dismiss keyboard when tapping outside
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111D2C),
        body: Stack(
          children: [
            // Background Image with Opacity
            Positioned.fill(
              child: Opacity(
                opacity: 0.3, // 70% transparency
                child: Image.asset(
                  'assets/images/login_background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Foreground UI
            Column(
              children: [
                Expanded(
                  flex: 65,
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Image.asset(
                        'assets/images/logo_white_1024.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Username Field
                          TextFormField(
                            controller: _emailController,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 1.0,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFD9D9D9),
                              hintText: 'Correo electrónico',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                              enabledBorder: _normalBorder(
                                Colors.grey.shade400,
                                1,
                              ),
                              focusedBorder: _normalBorder(
                                const Color(0xFF676767),
                                1.5,
                              ),
                              errorBorder: _normalBorder(Colors.red, 1),
                              focusedErrorBorder: _normalBorder(
                                Colors.red,
                                1.5,
                              ),
                              errorStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
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
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                              enabledBorder: _normalBorder(
                                Colors.grey.shade400,
                                1,
                              ),
                              focusedBorder: _normalBorder(Colors.black, 1.5),
                              errorBorder: _normalBorder(Colors.red, 1),
                              focusedErrorBorder: _normalBorder(
                                Colors.red,
                                1.5,
                              ),
                              errorStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  setState(
                                        () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC107),
                                disabledBackgroundColor: const Color(
                                  0xFFFFC107,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                "¿No tienes una cuenta? ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/createUser');
                                },
                                child: const Text(
                                  "Regístrate aquí",
                                  style: TextStyle(
                                    color: Color(0xFFFFC107),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}