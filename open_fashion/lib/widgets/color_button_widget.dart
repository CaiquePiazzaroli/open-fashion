import 'package:flutter/material.dart';

class ColorButtonWidget extends StatelessWidget {
  final String colorName;
  final bool isSelected;

  const ColorButtonWidget({
    super.key,
    required this.colorName,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _getColor(colorName),
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
      ),
    );
  }

  Color _getColor(String name) {
    switch (name.toLowerCase()) {
      case 'black': return Colors.black;
      case 'white': return Colors.white;
      case 'red': return Colors.red;
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
      case 'yellow': return Colors.yellow;
      default: return Colors.grey;
    }
  }
}
