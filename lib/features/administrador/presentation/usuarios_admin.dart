import 'package:bridgecare/features/administrador/presentation/home_admin.dart';
import 'package:bridgecare/features/administrador/presentation/list_user_admin.dart';
import 'package:bridgecare/features/administrador/presentation/user_auth.dart';
import 'package:bridgecare/features/user_management/read_user/presentation/pages/read_user.dart';
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

class UsuariosAdmin extends StatelessWidget {
  const UsuariosAdmin({Key? key}) : super(key: key);

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
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                ),
                //Icono de retroceso a la izquierda
                Positioned(
                  top: 20,
                  left: 5,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeAdmin()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
                // ☰ Icono de menú a la derecha
                Positioned(
                  top: 20,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.more_vert, color: Color(0xff01579a), size: 50),
                    onPressed: () {
                      // Menú u otra acción
                    },
                  ),
                ),
              ],
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'Aceptar usuarios',
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (_) => DetallesUsuario(user:{},)),);
                      },
                      defaultColor: Color(0xccffffff),
                      pressedColor: Colors.white.withOpacity(0.2),
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Ver usuarios existentes',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => UsuariosListAdminScreen()),);
                      },
                      defaultColor: Color(0xccffffff),
                      pressedColor: Colors.white.withOpacity(0.2),
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