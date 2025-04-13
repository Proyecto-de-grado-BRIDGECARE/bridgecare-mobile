import 'package:bridgecare/features/administrador/usuarios_admin.dart';
import 'package:bridgecare/features/home/presentation/pages/home_page.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_inspection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  late PersistentTabController _controller;
  final GlobalKey keyNavBarHome = GlobalKey();
  final GlobalKey keyNavBarHistory = GlobalKey();
  final GlobalKey keyNavBarSettings = GlobalKey();

  //bool _tutorialStarted = false;
  double _navBarHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  /*void _updateTutorialState(bool isRunning) {
    setState(() {
      _tutorialStarted = isRunning;
    });
  }*/

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      InspeccionesPage(),
      UsuariosAdmin(),
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
          CupertinoIcons.person,
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
            /*if (_tutorialStarted)
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
              ),*/
          ],
        );
      },
    );
  }
}
