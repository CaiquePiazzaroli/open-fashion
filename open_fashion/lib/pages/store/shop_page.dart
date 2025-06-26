import 'package:flutter/material.dart';
import 'package:open_fashion/models/item.dart';
import 'package:open_fashion/pages/store/item_selected_page.dart';
import 'package:open_fashion/services/firestore_itens.dart';
import 'package:open_fashion/widgets/shop_page_widget.dart';

class ShopPage extends StatelessWidget {
  final int? category;
  ShopPage({this.category, super.key});

  Future<List<Map<String, dynamic>>> loadItens() async {
    FirestoreItens db = FirestoreItens();
    return await db.getItens();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadItens(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum item encontrado.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final itemJson = snapshot.data!;
          final shopListItens = itemJson.map((item) {
            return ShopPageWidget(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItemSelectedPage(idItem: item['id']),
                  ),
                );
              },
              item: Item(
                id: item['id'].toString(),
                imagePath: item['imagePath'],
                title: item['name'],
                subTitle: item['description'],
                price: item['value'],
              ),
            );
          }).toList();

          return GridView.builder(
            itemCount: shopListItens.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.4, // ajustado para evitar overflow
            ),
            itemBuilder: (context, index) => shopListItens[index],
          );
        },
      ),
    );
  }
}
