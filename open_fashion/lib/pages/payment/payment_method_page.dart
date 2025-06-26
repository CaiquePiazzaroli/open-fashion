import 'package:flutter/material.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  // Controllers para capturar os valores
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    // Liberar os controllers ao destruir o widget
    nameController.dispose();
    cardNumberController.dispose();
    expMonthController.dispose();
    expDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
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
                        child: Image.asset(
                          'assets/mastercard_logo.png',
                          width: 50,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Iris Watson",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("03/25", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [dot(true), dot(false), dot(false)],
                  ),
                ),

                SizedBox(height: 24),

                buildTextField("Name On Card", nameController),
                buildTextField("Card Number", cardNumberController),

                Row(
                  children: [
                    Expanded(child: buildTextField("Exp Month", expMonthController)),
                    SizedBox(width: 16),
                    Expanded(child: buildTextField("Exp Date", expDateController)),
                  ],
                ),
                buildTextField("CVV", cvvController),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        color: Colors.black,
        child: TextButton.icon(
          onPressed: () {
            // Pega os valores dos controllers
            final name = nameController.text;
            final cardNumber = cardNumberController.text;
            final expMonth = expMonthController.text;
            final expDate = expDateController.text;
            final cvv = cvvController.text;

            // Navega para a tela que exibe os dados
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSummaryPage(
                  name: name,
                  cardNumber: cardNumber,
                  expMonth: expMonth,
                  expDate: expDate,
                  cvv: cvv,
                ),
              ),
            );
          },
          icon: Image.asset('assets/Shopping bag.png'),
          label: Text(
            "Buy Now".toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget dot(bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: active ? Colors.orange : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// Nova tela que mostra os dados do formulário
class PaymentSummaryPage extends StatelessWidget {
  final String name;
  final String cardNumber;
  final String expMonth;
  final String expDate;
  final String cvv;

  const PaymentSummaryPage({
    super.key,
    required this.name,
    required this.cardNumber,
    required this.expMonth,
    required this.expDate,
    required this.cvv,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Summary")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name On Card: $name", style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text("Card Number: $cardNumber", style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text("Exp Month: $expMonth", style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text("Exp Date: $expDate", style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text("CVV: $cvv", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
