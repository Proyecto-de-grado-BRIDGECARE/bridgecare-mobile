import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final GlobalKey navBarKey;
  final GlobalKey searchButtonKey;
  final GlobalKey addButtonKey;
  final GlobalKey historyButtonKey;
  final GlobalKey settingsButtonKey;
  final Function(bool) onTutorialStateChanged;

  const HomePage({
    super.key,
    required this.navBarKey,
    required this.searchButtonKey,
    required this.addButtonKey,
    required this.historyButtonKey,
    required this.settingsButtonKey,
    required this.onTutorialStateChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TutorialCoachMark? tutorialCoachMark;

  static const List<String> imagenes = [
    'assets/images/puente-inicio.jpeg',
    'assets/images/puente-inicio.jpeg',
    'assets/images/puente-inicio.jpeg',
    'assets/images/puente-inicio.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _checkIfTutorialSeen();
  }

  Future<void> _checkIfTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenTutorial = prefs.getBool('hasSeenTutorial') ?? false;

    if (!hasSeenTutorial) {
      Future.delayed(Duration.zero, startTutorial);
    }
  }

  void startTutorial() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_areKeysAttached()) {
        setState(() {
          widget.onTutorialStateChanged(true);
        });

        tutorialCoachMark = TutorialCoachMark(
          targets: _buildTutorialTargets(),
          hideSkip: true,
          onFinish: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('hasSeenTutorial', true);

            setState(() {
              widget.onTutorialStateChanged(false);
            });
          },
        )..show(context: context);
      } else {
        debugPrint("One or more keys are not attached to a widget.");
      }
    });
  }

  bool _areKeysAttached() {
    return widget.navBarKey.currentContext != null &&
        widget.searchButtonKey.currentContext != null &&
        widget.addButtonKey.currentContext != null &&
        widget.historyButtonKey.currentContext != null &&
        widget.settingsButtonKey.currentContext != null;
  }

  List<TargetFocus> _buildTutorialTargets() {
    return [
      _buildTarget(
        "HomeButton",
        widget.navBarKey,
        "Este es el botón de inicio. Pulsa aquí para volver a la página principal.",
      ),
      _buildTarget(
        "SearchButton",
        widget.searchButtonKey,
        "Este es el botón de búsqueda. Úsalo para encontrar puentes.",
      ),
      _buildTarget(
        "AddButton",
        widget.addButtonKey,
        "Este es el botón \"Añadir\". Úsalo para añadir un inventario o inspección nuevos.",
      ),
      _buildTarget(
        "HistoryButton",
        widget.historyButtonKey,
        "Este es el botón Historial. Úsalo para ver actividades de creación de inventario/inspección de otros usuarios.",
      ),
      _buildTarget(
        "SettingsButton",
        widget.settingsButtonKey,
        "Este es el botón de Configuración. Úsalo para personalizar tu usuario y crear, borrar, o actualizar nuevos usuarios.",
        isLast: true,
      ),
    ];
  }

  TargetFocus _buildTarget(
    String identify,
    GlobalKey keyTarget,
    String description, {
    bool isLast = false,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      alignSkip: Alignment.topRight,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                description,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (isLast) {
                    tutorialCoachMark?.finish();
                  } else {
                    tutorialCoachMark?.next();
                  }
                },
                child: const Text("Entendido"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/bridgecare_logo.png',
          fit: BoxFit.contain,
          height: 150,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F0147),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: 150,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a BridgeCare',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'BridgeCare es una aplicación diseñada para facilitar la inspección y gestión de puentes, '
              'permitiendo a ingenieros y responsables de mantenimiento registrar y analizar información '
              'de manera eficiente.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: imagenes.map((path) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(path, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Características clave:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildFeatureItem(Icons.assignment, 'Inspección de Puentes',
                'Registra y documenta información estructural de manera detallada.'),
            _buildFeatureItem(Icons.cloud_upload, 'Sincronización Inteligente',
                'Guarda datos sin conexión y sincronízalos automáticamente cuando haya conexión.'),
            _buildFeatureItem(Icons.security, 'Seguridad',
                'Autenticación y control de acceso para proteger la información.'),
            _buildFeatureItem(Icons.analytics, 'Análisis de Datos',
                'Consulta reportes y toma decisiones basadas en datos en tiempo real.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF0F0147), size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
