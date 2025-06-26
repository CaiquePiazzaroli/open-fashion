import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_fashion/pages/payment/payment_method_page.dart';
import 'package:open_fashion/providers/cart_provider.dart';
import 'package:open_fashion/widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItens = context.watch<CartProvider>().items;

    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho")),
      body:
          cartItens.isEmpty
              ? const Center(child: Text("Seu carrinho está vazio."))
              : Column(
                children: [
                  Expanded(child: _Cart(cartItens: cartItens)),
                  BottomBar(cartItens: cartItens),
                ],
              ),
    );
  }
}

class _Cart extends StatelessWidget {
  final List<Map<String, dynamic>> cartItens;
  const _Cart({required this.cartItens});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartItens.length,
      itemBuilder: (context, index) {
        final item = cartItens[index];

        return CartItem(
          id: item['id'],
          imagePath: item['imagePath'],
          title: item['name'],
          subtitle: item['description'],
          price: item['value'],
          size: item['size'] ?? '',
          color: item['color'] ?? '',
          amount: item['amount'] ?? 1,
        );
      },
    );
  }
}

class BottomBar extends StatelessWidget {
  final List<Map<String, dynamic>> cartItens;
  const BottomBar({required this.cartItens});

  String getTotalPrice() {
    double total = 0;
    for (var item in cartItens) {
      final price = (item['value'] ?? 0).toDouble();
      final quantity = (item['amount'] ?? 1);
      total += price * quantity;
    }
    return total.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal", style: TextStyle(fontSize: 16)),
              Text(
                "R\$ ${getTotalPrice()}",
                style: const TextStyle(fontSize: 18, color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Frete, impostos e cupons são aplicados na finalização da compra.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentMethodPage()),
                );
              },
              icon: Image.asset('assets/Shopping bag.png', height: 24),
              label: const Text("Finalizar compra"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
