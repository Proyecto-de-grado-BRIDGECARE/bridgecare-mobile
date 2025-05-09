import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:bridgecare/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashToLoginTransition extends StatefulWidget {
  const SplashToLoginTransition({super.key});

  @override
  SplashToLoginTransitionState createState() => SplashToLoginTransitionState();
}

class SplashToLoginTransitionState extends State<SplashToLoginTransition> {
  double _opacity = 0.0;
  late ThemeProvider themeProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      _startTransition();
    });
  }

  void _startTransition() {
    // Check login status before transitioning
    AuthService().isLoggedIn().then((loggedIn) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (loggedIn) {
          themeProvider.setLightMode();
          setState(() {
            _opacity = 1.0; // Start fade-in
          });

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
