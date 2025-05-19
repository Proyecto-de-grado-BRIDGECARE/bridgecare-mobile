import 'package:bridgecare/features/administrador/presentation/list_puentes_admin.dart';
import 'package:bridgecare/features/administrador/presentation/list_user_admin.dart';
import 'package:bridgecare/features/administrador/presentation/usuarios_admin.dart';
import 'package:flutter/material.dart';

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

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

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
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                  ),
                ),
                //menu estatico ¡¡¡¡¡¡¡¡¡¡
                Positioned(
                  top: 45,
                  right: 5,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Color(0xff01579a), size: 55),
                    onSelected: (value) {
                      if (value == 'logout') {
                        // Acción para cerrar sesión
                        // Por ejemplo: limpiar token, navegar al login, etc.
                        Navigator.pushReplacementNamed(context, '/login'); // ajusta la ruta
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Cerrar sesión'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
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
                      text: 'Ver puentes',
                      onTap: () {
                       Navigator.push(context,MaterialPageRoute(builder: (_) => PuentesListAdminScreen()),);
                      },
                      defaultColor: Color(0xccffffff),
                      pressedColor: const Color.fromRGBO(255, 255, 255, 0.2),
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Ver usuarios',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => UsuariosListAdminScreen()),);
                      },
                      defaultColor: Color(0xccffffff),
                      pressedColor: const Color.fromRGBO(255, 255, 255, 0.2),
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
