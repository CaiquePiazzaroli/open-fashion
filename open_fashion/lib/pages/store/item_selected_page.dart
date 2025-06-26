import 'package:flutter/material.dart';
import 'package:open_fashion/providers/cart_provider.dart';
import 'package:open_fashion/services/firestore_itens.dart';
import 'package:open_fashion/widgets/color_button_widget.dart';
import 'package:open_fashion/widgets/size_button_widget.dart';
import 'package:provider/provider.dart';

class ItemSelectedPage extends StatelessWidget {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle priceStyle = TextStyle(
    fontSize: 28,
    color: Colors.orange,
  );

  final String idItem;

  const ItemSelectedPage({super.key, required this.idItem});

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(title: Text("Store")),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        color: Colors.black,
        child: TextButton(
          onPressed: () {
            FirestoreItens().getItemById(idItem).then((item) {
              if (item != null) {
                Provider.of<CartProvider>(context, listen: false).addItem(item);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${item['name']} adicionado ao carrinho"),
                  ),
                );
              }
            });
          },
          child: Text("+ ADD CART", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirestoreItens().getItemById(idItem),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Erro ao carregar item."));
          }

          final item = snapshot.data!;
          final List<String> colors = List<String>.from(item['colors'] ?? []);
          final List<String> sizes = List<String>.from(item['sizes'] ?? []);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              Image.network(
                item['imagePath'],
                width: screenSize - 32,
                height: screenHeight / 2,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 8),
              Text(item['name'], style: titleStyle),
              const SizedBox(height: 8),
              Text(item['description'], style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("R\$${item['value']}", style: priceStyle),
              const SizedBox(height: 16),
              _buildColorAndSizeSelectors(colors, sizes),
            ],
          );
        },
      ),
    );
  }

  /// Widget que exibe botões de cores e tamanhos
  Widget _buildColorAndSizeSelectors(List<String> colors, List<String> sizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (colors.isNotEmpty) ...[
          Text("Cores:"),
          Wrap(
            spacing: 8,
            children:
                colors
                    .map((color) => ColorButtonWidget(colorName: color))
                    .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (sizes.isNotEmpty) ...[
          Text("Tamanhos:"),
          Wrap(
            spacing: 8,
            children:
                sizes.map((size) => SizeButtonWidget(size: size)).toList(),
          ),
        ],
      ],
    );
  }
}
