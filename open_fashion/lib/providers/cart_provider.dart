import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  /// Adiciona item ao carrinho, somando quantidade se item já existir
  void addItem(Map<String, dynamic> newItem) {
    final index = _items.indexWhere((item) =>
        item['id'] == newItem['id'] &&
        item['size'] == newItem['size'] &&
        item['color'] == newItem['color']);

    if (index != -1) {
      _items[index]['amount'] += newItem['amount'] ?? 1;
    } else {
      _items.add({
        ...newItem,
        'amount': newItem['amount'] ?? 1,
      });
    }

    notifyListeners();
  }

  /// Remove completamente um item
  void removeItem(Map<String, dynamic> itemToRemove) {
    _items.removeWhere((item) =>
        item['id'] == itemToRemove['id'] &&
        item['size'] == itemToRemove['size'] &&
        item['color'] == itemToRemove['color']);
    notifyListeners();
  }

  /// Atualiza a quantidade de um item
  void updateItemAmount(String id, String size, String color, int newAmount) {
    final index = _items.indexWhere((item) =>
        item['id'] == id && item['size'] == size && item['color'] == color);

    if (index != -1) {
      _items[index]['amount'] = newAmount;
      notifyListeners();
    }
  }

  /// Limpa o carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Calcula o total
  double get total {
    return _items.fold(0.0, (sum, item) {
      final price = (item['value'] ?? 0).toDouble();
      final quantity = (item['amount'] ?? 1);
      return sum + price * quantity;
    });
  }
}
