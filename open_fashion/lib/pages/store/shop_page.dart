import 'package:flutter/material.dart';
import 'package:open_fashion/models/item.dart';
import 'package:open_fashion/pages/store/item_selected_page.dart';
import 'package:open_fashion/services/firestore_itens.dart';
import 'package:open_fashion/widgets/shop_page_widget.dart';

class ShopPage extends StatefulWidget {
  final int? category;
  const ShopPage({this.category, super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoading = true;
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItens();
  }

  Future<void> loadItens() async {
    FirestoreItens db = FirestoreItens();
    final items = await db.getItens();
    setState(() {
      allItems = items;
      filteredItems = items;
      isLoading = false;
    });
  }

  void _filterItems(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredItems =
          allItems.where((item) {
            final name = item['name']?.toLowerCase() ?? '';
            return name.contains(searchQuery);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _filterItems,
            decoration: InputDecoration(
              hintText: 'Pesquisar produto...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                isLoading
                    ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                    : filteredItems.isEmpty
                    ? const Center(
                      child: Text(
                        'Nenhum item encontrado.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                            childAspectRatio:
                                0.44,
                          ),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ShopPageWidget(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ItemSelectedPage(idItem: item['id']),
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
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
