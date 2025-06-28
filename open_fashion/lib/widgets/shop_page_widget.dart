import 'package:flutter/material.dart';
import 'package:open_fashion/models/item.dart';

class ShopPageWidget extends StatelessWidget {
  final Item item;
  final VoidCallback onPressed;

  const ShopPageWidget({
    super.key,
    required this.onPressed,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.getImagePath(),
                height: 250, // imagem maior
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.getTitle(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              item.getSubtitle(),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              maxLines: 4, // mais linhas
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'R\$${item.getPrice().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
