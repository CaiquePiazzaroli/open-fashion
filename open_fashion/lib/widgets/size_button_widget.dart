import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeButtonWidget extends StatelessWidget{

  String size = '';

  SizeButtonWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
            width: 30,
            height: 30,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<CircleBorder>(
                  CircleBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              onPressed: () {
                // ação ao clicar
              },
              child: Text(
                this.size,
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
          )
        ),
    );
  }}