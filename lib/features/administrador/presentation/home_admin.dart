import 'package:flutter/material.dart';
import 'package:bridgecare/features/administrador/presentation/list_user_admin.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
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
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 45,
                          right: 10,
                          child: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert,
                                color: Color(0xff01579a), size: 35),
                            onSelected: (value) {
                              if (value == 'logout') {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
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
                    const SizedBox(height: 80),
                    const Text(
                      'Usted desea:',
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                    const SizedBox(height: 80),

                    // Botón desplegable Puentes
                    Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xccffffff), // ✅ defaultColor
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent, // Quita línea divisoria
                              splashColor: Colors.white.withOpacity(0.2), // ✅ pressedColor
                            ),
                            child: ExpansionTile(
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              title: const Text(
                                'Puentes',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // ✅ textColor
                                ),
                              ),
                              children: [
                                ListTile(
                                  title: const Text('Ver Puentes'),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/puenteslistAdmin');
                                  },
                                ),
                                ListTile(
                                  title: const Text('Crear Puente'),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/forminventario');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),


                    const SizedBox(height: 20),

                    // Botón desplegable Usuarios
                    Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xccffffff), // Fondo del botón (defaultColor)
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent, // Quita líneas internas
                              splashColor: Colors.white.withOpacity(0.2), // Color al presionar
                            ),
                            child: ExpansionTile(
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              title: const Text(
                                'Usuarios',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Color del texto
                                ),
                              ),
                              children: [
                                ListTile(
                                  title: const Text('Ver Usuarios'),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/usuarioslistAdmin');
                                  },
                                ),
                                ListTile(
                                  title: const Text('Crear Usuario'),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/createUser');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),


                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
