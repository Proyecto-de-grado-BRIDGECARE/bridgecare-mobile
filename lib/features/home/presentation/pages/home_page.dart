import 'package:bridgecare/features/administrador/puentes_admin.dart';
import 'package:bridgecare/features/bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color defaultColor;
  final Color pressedColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.defaultColor,
    required this.pressedColor,
    required this.textColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        height: 70,
        width: 300,
        decoration: BoxDecoration(
          color: _isPressed ? widget.pressedColor : widget.defaultColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff3ab4fb),
              Color(0xff281537),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 0),
            // Animación del puente
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100.0),
                      bottomRight: Radius.circular(100.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Lottie.asset(
                    'assets/animations/puente.json',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Usted desea:',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'Crear nuevo puente',
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          // TODO CHANGE INSPECTION TO INVENTARIO
                          screen: InspectionFormScreen(
                            puenteId: 1,
                          ),
                          withNavBar: false,
                        );
                      },
                      defaultColor: Color(0xccffffff),
                      pressedColor: const Color.fromRGBO(255, 255, 255, 0.2),
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Buscar un puente',
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: PuentesAdmin(),
                          withNavBar: false,
                        );
                      },
                      defaultColor: Color(0xccffffff),
                      pressedColor: const Color.fromRGBO(255, 255, 255, 0.2),
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, color: Colors.white, size: 25),
                SizedBox(width: 7),
                Text(
                  'Manual',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 32.0),
            ),
            const SizedBox(height: 42),
          ],
        ),
      ),
    );
  }
}
