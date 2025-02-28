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

  @override
  void initState() {
    _checkIfTutorialSeen();
    super.initState();
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
          onFinish: () {
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
      _buildTarget("HomeButton", widget.navBarKey, "This is the Home button! Tap here to go back to the main page."),
      _buildTarget("SearchButton", widget.searchButtonKey, "This is the Search button! Use it to find bridges."),
      _buildTarget("AddButton", widget.addButtonKey, "This is the Add button! Use it to add new content."),
      _buildTarget("HistoryButton", widget.historyButtonKey, "This is the History button! Use it to view past activities."),
      _buildTarget("SettingsButton", widget.settingsButtonKey, "This is the Settings button! Use it to customize the app.", isLast: true),
    ];
  }

  TargetFocus _buildTarget(String identify, GlobalKey keyTarget, String description, {bool isLast = false}) {
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
              Text(description, style: const TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (isLast) {
                    tutorialCoachMark?.finish();
                  } else {
                    tutorialCoachMark?.next();
                  }
                },
                child: const Text("Got it"),
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
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: const Text("Welcome to Home Page!"),
            ),
          ),
        ],
      ),
    );
  }
}
