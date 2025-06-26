// lib/widgets/cart_item_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_fashion/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String imagePath;
  final String title;
  final String subtitle;
  final double price;
  final String size;
  final String color;
  final int amount;

  const CartItem({
    super.key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.size,
    required this.color,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Image.network(imagePath, height: 120, width: 100, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Text("Cor: $color | Tamanho: $size", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (amount > 1) {
                          cart.updateItemAmount(id, size, color, amount - 1);
                        } else {
                          cart.removeItem({
                            'id': id,
                            'size': size,
                            'color': color,
                          });
                        }
                      },
                    ),
                    Text(amount.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        cart.updateItemAmount(id, size, color, amount + 1);
                      },
                    ),
                  ],
                ),
                Text("R\$ ${(price * amount).toStringAsFixed(2)}", style: const TextStyle(color: Colors.orange)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
