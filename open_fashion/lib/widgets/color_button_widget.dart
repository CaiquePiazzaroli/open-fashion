import 'package:flutter/material.dart';

class ColorButtonWidget extends StatelessWidget {
  String colorName = '';

  ColorButtonWidget({super.key, required this.colorName});

  @override
  Widget build(BuildContext context) {

    Map colors = {
      'black': Colors.black,
      'white': Colors.white,
      'orange': Colors.orange,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 30,
        height: 30,
        child: TextButton(
          onPressed: () {
            print(colorName);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(colors[colorName]),
            shape: WidgetStateProperty.all(
              CircleBorder(
                side: BorderSide(color: Colors.black, width: 1)
              )
            ),
          ),
          child: Text('')),
      ),
    );
  }

}