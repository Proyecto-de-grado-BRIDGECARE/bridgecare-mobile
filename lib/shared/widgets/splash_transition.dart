import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:bridgecare/features/auth/services/auth_service.dart';
import 'package:bridgecare/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashToLoginTransition extends StatefulWidget {
  const SplashToLoginTransition({super.key});

  @override
  SplashToLoginTransitionState createState() => SplashToLoginTransitionState();
}

class SplashToLoginTransitionState extends State<SplashToLoginTransition> {
  double _opacity = 0.0;
  late ThemeProvider themeProvider;
  bool _isLoading = true;
  int? usuarioId;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      _startTransition();
    });
  }

  void _startTransition() {
    debugPrint('start_transition');
    // Check login status before transitioning
    AuthService().isLoggedIn().then((loggedIn) {
      debugPrint('user is logged in');
      Future.delayed(Duration(milliseconds: 300), () async {
        if (loggedIn) {
          themeProvider.setLightMode();
          setState(() {
            _opacity = 1.0; // Start fade-in
          });

          final user = await _authService.getUser();
          if (user != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('usuario_id', user.id!);
            await prefs.setInt('tipo_usuario', user.tipoUsuario);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomePage(
                  usuarioId: user.id!,
                  tipoUsuario: user.tipoUsuario,
                ),
              ),
            );
          } else {
            debugPrint('⚠️ Error: no se pudo obtener el usuario');
          }
        } else {
          setState(() {
            _opacity = 1.0; // Trigger fade-in to login
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF111D2C), // Splash screen background
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000), // Fade-in duration
        opacity: _opacity,
        child: _isLoading ? SizedBox() : LoginPage(),
      ),
    );
  }
}
