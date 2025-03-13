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
        child: Column(
          children: [
            GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Bienvenido a BridgeCare, la aplicación para el diagnostico del estado de un puente',
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
