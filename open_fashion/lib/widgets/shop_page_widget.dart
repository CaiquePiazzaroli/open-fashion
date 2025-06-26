import 'package:flutter/material.dart';
import 'package:open_fashion/models/item.dart';

class ShopPageWidget extends StatefulWidget {
  //Atributos
  final Item item;
  final VoidCallback onPressed;

  //Construtor
  const ShopPageWidget({
    super.key,
    required this.onPressed,
    required this.item,
  });

  @override
  State<ShopPageWidget> createState() => _StoreItemWidgetState();
}

class _StoreItemWidgetState extends State<ShopPageWidget> {
  TextStyle titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle priceStyle = TextStyle(fontSize: 16, color: Colors.orange);

  @override
  Widget build(BuildContext context) {
    //Permite a utilização do ontap
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Image.network(widget.item.getImagePath(), height: 240),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [Text(widget.item.getTitle(), style: titleStyle)],
                  ),
                  Wrap(children: [Text(widget.item.getSubtitle())]),
                  Row(
                    children: [
                      Text('R\$${widget.item.getPrice()}', style: priceStyle),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
