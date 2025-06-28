import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserOrdersPage extends StatefulWidget {
  const UserOrdersPage({super.key});

  @override
  State<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  String? userId;
  bool isLoading = true;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    userId = user.uid;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('user', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      print(snapshot);

      setState(() {
        orders = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar pedidos.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Pedidos")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("Você ainda não fez nenhum pedido."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final date = (order['date'] as Timestamp).toDate();

                    final List<dynamic> itens = order['itens'] ?? [];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        title: Text("Pedido #${order['id']}"),
                        subtitle: Text(
                          "Data: ${date.day}/${date.month}/${date.year} às ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                        ),
                        children: itens.map((item) {
                          final itemMap = item as Map<String, dynamic>;

                          final name = itemMap['name'] ?? 'Sem nome';
                          final imagePath = itemMap['imagePath'] ?? '';
                          final color = itemMap['color'] ?? '-';
                          final size = itemMap['size'] ?? '-';
                          final quantity = itemMap['quantity']?.toString() ?? '1';

                          return ListTile(
                            leading: imagePath.isNotEmpty
                                ? Image.network(
                                    imagePath,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(name),
                            subtitle: Text("Tamanho: $size • Cor: $color"),
                            trailing: Text("x$quantity"),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
    );
  }
}
