import 'package:bridgecare/features/home/presentation/pages/home_page.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_bridge.dart';
import 'package:bridgecare/features/bridge_management/inventory/presentation/pages/form_inventario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:bridgecare/features/user_management/read_user/presentation/pages/read_user.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  late PersistentTabController _controller;
  final GlobalKey keyNavBarHome = GlobalKey();
  final GlobalKey keyNavBarSearch = GlobalKey();
  final GlobalKey keyNavBarAdd = GlobalKey();
  final GlobalKey keyNavBarHistory = GlobalKey();
  final GlobalKey keyNavBarSettings = GlobalKey();

  bool _tutorialStarted = false;
  double _navBarHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  void _updateTutorialState(bool isRunning) {
    setState(() {
      _tutorialStarted = isRunning;
    });
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(
        navBarKey: keyNavBarHome,
        searchButtonKey: keyNavBarSearch,
        addButtonKey: keyNavBarAdd,
        historyButtonKey: keyNavBarHistory,
        settingsButtonKey: keyNavBarSettings,
        onTutorialStateChanged: _updateTutorialState,
      ),
      BridgeListScreen(),
      FormInventario(),
      const SettingsScreen(),
      ListaUsuarios(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems(double iconSize) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home, key: keyNavBarHome, size: iconSize),
        title: "Home",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.search, key: keyNavBarSearch, size: iconSize),
        title: "Search",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.add, key: keyNavBarAdd, size: iconSize),
        title: "Add",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.doc_text,
          key: keyNavBarHistory,
          size: iconSize,
        ),
        title: "History",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.settings,
          key: keyNavBarSettings,
          size: iconSize,
        ),
        title: "Settings",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double estimatedNavBarHeight = constraints.maxHeight * 0.08;
        double iconSize = constraints.maxHeight * 0.03;

        if (_navBarHeight == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _navBarHeight = estimatedNavBarHeight;
            });
          });
        }

        return Stack(
          children: [
            PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarItems(iconSize),
              confineToSafeArea: true,
              backgroundColor: const Color.fromARGB(255, 235, 235, 235),
              navBarStyle: NavBarStyle.style12,
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            if (_tutorialStarted)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  ignoring: false,
                  child: Container(
                    height: _navBarHeight,
                    color: Colors.transparent,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Screen")),
      body: const Center(child: Text("Add Screen Content")),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Screen")),
      body: const Center(child: Text("History Screen Content")),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings Screen")),
      body: const Center(child: Text("Settings Screen Content")),
    );
  }
}
