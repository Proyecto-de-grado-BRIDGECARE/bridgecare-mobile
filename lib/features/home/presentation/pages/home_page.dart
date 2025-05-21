import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bridgecare/features/bridge_management/inventory/presentation/pages/inventario_form_page.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_bridge.dart';

class HomePage extends StatefulWidget {
  final int usuarioId;
  final int tipoUsuario;

  const HomePage({
    super.key,
    required this.usuarioId,
    required this.tipoUsuario,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  String? expandedTile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff3ab4fb), Color(0xff281537)],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 50),
            const Text(
              'Usted desea:',
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (widget.tipoUsuario == 0 || widget.tipoUsuario == 1) {
                    return _buildStudentOptions(context);
                  } else if (widget.tipoUsuario == 2) {
                    return _buildAdminOptions(context);
                  } else {
                    return Center(
                      child: Text(
                        'Tipo de usuario no reconocido: ${widget.tipoUsuario}',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }
                },
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, color: Colors.white, size: 25),
                SizedBox(width: 7),
                Text('Manual', style: TextStyle(fontSize: 17, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100.0),
              bottomRight: Radius.circular(100.0),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 5,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xff01579a), size: 50),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Cerrar sesión')),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: Lottie.asset('assets/animations/puente.json'),
        ),
      ],
    );
  }
  Widget _buildStudentOptions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          context,
          text: 'Crear nuevo puente',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InventoryFormScreen(usuarioId: widget.usuarioId),
            ),
          ),
        ),
        const SizedBox(height: 30),
        _buildButton(
          context,
          text: 'Buscar un puente',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BridgeListScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminOptions(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildExpandableTile(
            context,
            title: 'Puentes',
            keyValue: 'puentes',
            options: {
              'Ver Puentes': '/puenteslistAdmin',
              'Crear Puente': '/forminventario',
            },
          ),
          const SizedBox(height: 30),
          _buildExpandableTile(
            context,
            title: 'Usuarios',
            keyValue: 'usuarios',
            options: {
              'Ver Usuarios': '/usuarioslistAdmin',
              'Crear Usuario': '/createUser',
            },
          ),
        ],
      ),
    );
  }

  //estilos del home de estudiante
  Widget _buildButton(BuildContext context,
      {required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 300,
        decoration: BoxDecoration(
          color: const Color(0xccffffff),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
  //estilos del home de admin
  Widget _buildExpandableTile(
      BuildContext context, {
        required String title,
        required String keyValue,
        required Map<String, String> options,
      }) {
    final entries = options.entries.toList();
    final isExpanded = expandedTile == keyValue;

    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xccffffff),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            key: UniqueKey(),
            initiallyExpanded: isExpanded,
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                expandedTile = expanded ? keyValue : null;
              });
            },
            children: List.generate(entries.length * 2 - 1, (index) {
              if (index.isEven) {
                final entry = entries[index ~/ 2];
                return ListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 18, // ⬅️ Ajusta este valor según lo que necesites
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  onTap: () => Navigator.pushNamed(context, entry.value),
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              } else {
                return const Divider(
                  color: Color(0x33000000), // línea divisoria suave
                  thickness: 1,
                  height: 16,
                );
              }
            }),
          ),
        ),
      ),
    );
  }

}
