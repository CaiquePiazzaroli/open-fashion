import 'package:flutter/material.dart';
import 'package:open_fashion/mocks/shop_page_itens_mock.dart';
import 'package:open_fashion/models/item.dart';
import 'package:open_fashion/pages/item_selected_page.dart';
import 'package:open_fashion/widgets/shop_page_widget.dart';

class ShopPage extends StatelessWidget {
  final int? category;

  ShopPage({this.category, super.key});

  @override
  Widget build(BuildContext context) {

    //Representa uma requisição HTTP
    //Usar o category para buscar os itens com o getItem
    List<Map> itemJson = ShopPageItensMock.getItem();

    List<ShopPageWidget> shopListItens = itemJson.map((item) {
      return ShopPageWidget(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemSelectedPage(idItem: item['id']),
            ),
          );
        },
        item: Item(
          id: item['id'],
          imagePath: item['imagepath'],
          title: item["title"],
          subTitle: item["subtitle"],
          price: item["price"],
        ),
      );
    }).toList();

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.2/1, //Controla o tamanho do card
      children: shopListItens,
    );
  }
}
