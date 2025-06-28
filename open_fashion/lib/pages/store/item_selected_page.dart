import 'package:flutter/material.dart';
import 'package:open_fashion/providers/cart_provider.dart';
import 'package:open_fashion/services/firestore_itens.dart';
import 'package:open_fashion/widgets/color_button_widget.dart';
import 'package:open_fashion/widgets/size_button_widget.dart';
import 'package:provider/provider.dart';

class ItemSelectedPage extends StatefulWidget {
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
  State<ItemSelectedPage> createState() => _ItemSelectedPageState();
}

class _ItemSelectedPageState extends State<ItemSelectedPage> {
  String? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(title: const Text("Store")),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        color: Colors.black,
        child: TextButton(
          onPressed: () async {
            final item = await FirestoreItens().getItemById(widget.idItem);
            if (item == null) return;

            if (selectedColor == null || selectedSize == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Selecione uma cor e um tamanho.")),
              );
              return;
            }

            final itemToAdd = {
              ...item,
              'color': selectedColor,
              'size': selectedSize,
              'amount': 1,
            };

            Provider.of<CartProvider>(context, listen: false).addItem(itemToAdd);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${item['name']} adicionado ao carrinho")),
            );
          },
          child: const Text("+ ADD CART", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirestoreItens().getItemById(widget.idItem),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Erro ao carregar item."));
          }

          final item = snapshot.data!;
          final List<String> colors = List<String>.from(item['colors'] ?? []);
          final List<String> sizes = List<String>.from(item['sizes'] ?? []);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              Image.network(
                item['imagePath'],
                width: screenSize - 42,
                height: screenHeight / 2  ,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 8),
              Text(item['name'], style: ItemSelectedPage.titleStyle),
              const SizedBox(height: 8),
              Text(item['description'], style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("R\$${item['value']}", style: ItemSelectedPage.priceStyle),
              const SizedBox(height: 16),
              _buildColorAndSizeSelectors(colors, sizes),
            ],
          );
        },
      ),
    );
  }

  /// Widget para exibir botões de cor e tamanho com seleção controlada
  Widget _buildColorAndSizeSelectors(List<String> colors, List<String> sizes) {
    return Row(
      children: [
        if (colors.isNotEmpty) ...[
          const Text("Cores:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: colors.map((color) {
              final isSelected = selectedColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: ColorButtonWidget(
                  colorName: color,
                  isSelected: isSelected,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        Padding(padding: EdgeInsets.all(6)),
        if (sizes.isNotEmpty) ...[
          const Text("Tamanhos:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: sizes.map((size) {
              final isSelected = selectedSize == size;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = size;
                  });
                },
                child: SizeButtonWidget(
                  size: size,
                  isSelected: isSelected,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
