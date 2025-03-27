import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/core/widgets/navbar.dart';
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
      _checkTokenAndTransition();
    });
  }

  Future<void> _checkTokenAndTransition() async {
    // Start fade-in immediately
    setState(() {
      _opacity = 1.0;
    });

    bool isValidToken = await AuthService().validateToken();

    if (isValidToken) {
      themeProvider.setLightMode();
      // Navigate to main screen with fade transition
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BottomNavWrapper(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    } else {
      // Show login page after fade-in completes
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ignore: unused_element
  void _startTransition() {
    // Check login status before transitioning
    AuthService().isLoggedIn().then((loggedIn) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (loggedIn) {
          themeProvider.setLightMode();
          setState(() {
            _opacity = 1.0; // Start fade-in
          });
          Future.delayed(Duration(milliseconds: 1000), () {
            // Match fade duration
            if (mounted) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BottomNavWrapper(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 1000),
                ),
              );
            }
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
