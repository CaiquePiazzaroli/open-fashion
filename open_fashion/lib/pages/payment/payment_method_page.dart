import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_fashion/providers/cart_provider.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expMonthController.dispose();
    expDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> _processOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final cartItems = context.read<CartProvider>().items;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você precisa estar logado para finalizar a compra.")),
      );
      return;
    }

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("O carrinho está vazio.")),
      );
      return;
    }

    final List<Map<String, dynamic>> itensList = cartItems.map((item) {
      return {
        'id': item['id'],
        'name': item['name'],
        'imagePath': item['imagePath'],
        'color': item['color'],
        'size': item['size'],
        'quantity': item['amount'],
      };
    }).toList();

    final orderData = {
      'date': Timestamp.now(),
      'user': user.uid,
      'itens': itensList,
    };

    print('Order data: $orderData');

    try {
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      context.read<CartProvider>().clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido realizado com sucesso!")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao processar pedido: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forma de Pagamento")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      "PAYMENT METHOD",
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildCreditCardPreview(),
                  const SizedBox(height: 24),
                  buildTextField(
                    "Name On Card",
                    nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Campo obrigatório";
                      return null;
                    },
                  ),
                  buildTextField(
                    "Card Number",
                    cardNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.length < 16) return "Número de cartão inválido";
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          "Exp Month",
                          expMonthController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Obrigatório";
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: buildTextField(
                          "Exp Year",
                          expDateController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Obrigatório";
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  buildTextField(
                    "CVV",
                    cvvController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.length != 3) return "CVV inválido";
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        color: Colors.black,
        child: TextButton.icon(
          onPressed: () => _processOrder(context),
          icon: Image.asset('assets/Shopping bag.png', height: 24),
          label: const Text(
            "Buy Now",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildCreditCardPreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.black87, Colors.black54],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/mastercard_logo.png', width: 50),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Iris Watson", style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 4),
              Text(
                "2365 3654 2365 3698",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text("03/25", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
