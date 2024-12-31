import 'package:flutter/material.dart';
import 'package:bridgecare/features/home/presentation/widgets/home_bottom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instead of returning a Scaffold, return BottomNavWrapper
    return const BottomNavWrapper();
  }
}