import 'package:flutter/material.dart';
import 'package:open_fashion/models/item.dart';
import 'package:open_fashion/pages/payment_method_page.dart';
import 'package:open_fashion/widgets/cart_item_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItens = [
    CartItem(
      item: Item(
        imagePath: "assets/blusa1.png",
        title: "Blusa Canelada Feminina",
        subTitle: "Blusa de malha canelada, ideal para dias amenos",
        price: 89.9,
        color: "black",
        size:'M',
      ),
      amount: 1,
    ),
    CartItem(
      item: Item(
        imagePath: "assets/blusa2.png",
        title: "Casaco Moletom Oversized",
        subTitle: "Casaco de moletom sem capuz",
        price: 159.99,
        color: "black",
        size: 'M',
      ),
      amount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Column(
        children: [Cart(cartItens: cartItens), BottomBar(cartItens: cartItens)],
      ),
    );
  }
}

class Cart extends StatelessWidget {
  const Cart({super.key, required this.cartItens});
  final List<CartItem> cartItens;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                "cart".toUpperCase(),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: ListView(children: cartItens)),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.cartItens});
  final List<CartItem> cartItens;

  String getTotalPrice() {
    double totalPrice = 0;

    for (var cartItem in cartItens) {
      totalPrice += cartItem.getTotalPrice();
    }

    return totalPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal".toUpperCase()),
                  Text(
                    "${getTotalPrice()}R\$",
                    style: TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(16)),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Shipping charges, taxes and discount codesare calculated at the time of accounting",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          width: double.infinity,
          color: Colors.black,
          child: TextButton.icon(
            onPressed:
                () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodPage(),
                    ),
                  ),
                },
            icon: Image.asset('assets/Shopping bag.png'),
            label: Text(
              "Buy Now".toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
