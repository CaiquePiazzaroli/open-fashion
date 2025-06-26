import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreItens {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Busca todos os itens
  Future<List<Map<String, dynamic>>> getItens() async {
    final List<Map<String, dynamic>> itens = [];
    try {
      final snapshot = await db.collection("itens").get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id; // inclui o id do documento no mapa
        itens.add(data);
      }
    } catch (e) {
      print("Erro ao buscar itens: $e");
    }
    return itens;
  }

  // 🔍 Busca um item específico pelo ID
  Future<Map<String, dynamic>?> getItemById(String id) async {
    try {
      final doc = await db.collection("itens").doc(id).get();

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id; // adiciona o ID ao mapa
        return data;
      } else {
        print("Item com id $id não encontrado.");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar item por ID: $e");
      return null;
    }
  }
}
