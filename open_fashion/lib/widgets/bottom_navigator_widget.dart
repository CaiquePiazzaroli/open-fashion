import 'package:flutter/material.dart';


class BottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const BottomNavWidget({super.key, required this.currentIndex, required this.onItemTapped});
  @override
  BottomNavigationBar build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Store"),
        BottomNavigationBarItem(icon: Icon(Icons.account_box), label: "Meus dados"),
      ],
      onTap: onItemTapped,
    );
  }
}
