import 'package:flutter/material.dart';
import 'package:open_fashion/pages/store/cart_page.dart';

class FloatButton extends StatelessWidget {
  const FloatButton({super.key});

  @override
  FloatingActionButton build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () => {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => CartPage())
        )
      },
      child: Image.asset('assets/Shopping bag.png'),);
  }

}