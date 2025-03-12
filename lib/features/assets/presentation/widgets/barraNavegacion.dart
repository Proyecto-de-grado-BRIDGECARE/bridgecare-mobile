import 'package:flutter/material.dart';

class barraNavegacion extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const barraNavegacion(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              color: Color(0xffCCCCCC),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _constructorItem(Icons.list, 0),
              _constructorItem(Icons.search, 1),
              _constructorItem(Icons.add, 2),
              _constructorItem(Icons.person, 3)
            ],
          )),
    );
  }

  Widget _constructorItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
        onTap: () => onItemTapped(index),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xff111D2C) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            )));
  }
}
