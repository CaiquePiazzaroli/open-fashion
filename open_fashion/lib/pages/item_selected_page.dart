import 'package:flutter/material.dart';
import 'package:open_fashion/mocks/detail_page_itens.dart';

class ItemSelectedPage extends StatelessWidget {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle priceStyle = TextStyle(
    fontSize: 16,
    color: Colors.orange,
  );

  //Propriedade idItem
  final int idItem;

  //Construtor que recebe id item da tela de shop
  const ItemSelectedPage({super.key, required this.idItem});

  List<Map> _getItemVariants() {
    //Representa a api com todas as variantes dos itens
    List<Map> detailItens = DetailPageItens.getDetailPageItens();

    //Retorna uma lista com apenas as variantes do item selecionado
    return detailItens.where((item) => item['id'] == idItem).toList();
  }

  //busca os atributos de cor e tamanho do produto a fim de saber todas as opções disponíveis
  Map _getAttributeVariants() {
    //Cria duas listas vazias para armazenar os atributos de cor e tamanho
    List<String> colorsList = [];
    List<String> sizesList = [];

    //Popula as listas com todas as cores e tamanhos disponíveis de uma peça de roupa
    _getItemVariants().forEach((item) {
      colorsList.add(item['color']);
      sizesList.add(item['size']);
    });

    //toSet() == Remove valores duplicados, por ex [white, white, black] => [white, black]
    return {
      'colors': colorsList.toSet().toList(),
      'sizes': sizesList.toSet().toList(),
    };
  }

  Map _getItemSelected() {
    //Seleciona o item de acordo com as variantes selecionada pelo usuário
    return _getItemVariants().firstWhere(
      //(item) => item["id"] == idItem && item['color'] == 'white',
      (item) => item["id"] == idItem,

      ///Tratar este erro
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    //Variável para identificar o tamanho da tela
    double screenSize = MediaQuery.sizeOf(context).width;

    //Recebe o item selecionado pelo id
    Map itemSelected = _getItemSelected();

    //recebe todos os atributos (cor e tamanho) de uma dado item
    Map attributeVariants = _getAttributeVariants();

    return Scaffold(
      appBar: AppBar(title: Text("Store")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize,
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      width: screenSize,
                      alignment: Alignment.center,
                      itemSelected['imagepath'],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(6)),
                title(itemSelected),
                Padding(padding: EdgeInsets.all(2)),
                subtitle(itemSelected),
                Padding(padding: EdgeInsets.all(2)),
                price(itemSelected),
                Padding(padding: EdgeInsets.all(2)),
                ColorAndSize(itemSelected, attributeVariants),
                Padding(padding: EdgeInsets.all(2)),
                Text(itemSelected['color']),
              ],
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.black,
            child: TextButton(
              onPressed: () => {print("aa")},
              child: Text("+ ADD CART", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  //Titulo
  Container title(Map<dynamic, dynamic> itemSelected) => Container(
    padding: EdgeInsets.only(left: 29),
    child: Row(children: [Text(itemSelected['title'], style: titleStyle)]),
  );


  //Subtitulo
  Container subtitle(Map<dynamic, dynamic> itemSelected) {
    return Container(
      padding: EdgeInsets.only(left: 29),
      child: Row(
        children: [
          Text(itemSelected['subtitle'], style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  //Preço
  Container price(Map<dynamic, dynamic> itemSelected) {
    return Container(
      padding: EdgeInsets.only(left: 29),
      child: Row(
        children: [Text("R\$${itemSelected['price']}", style: priceStyle)],
      ),
    );
  }

  Container ColorAndSize(Map itemSelected, Map attributeVariants) {

    //Container de tamanho
    Container size(String size) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        width: 20,
        height: 20,
        child: Center(child: Text(size)),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 29),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Text("Cores: "),
                //Errado: attributeVariants['colors'].map((attribute) => {Text(attribute)})
                ...attributeVariants['colors'].map((item) => Text(item)),

                // Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black,), width: 14, height: 14),
                // Padding(padding: EdgeInsets.all(2)),
                // Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange,), width: 14, height: 14),
                // Padding(padding: EdgeInsets.all(2)),
                // Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey,), width: 14, height: 14),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(4)),
          Expanded(
            child: Row(
              children: [
                Text("Tamanho"),

                //Errado: attributeVariants['sizes'].map((attribute) => {Text(attribute)})
                ...attributeVariants['sizes'].map((item) => Text(item)),

                // Padding(padding: EdgeInsets.all(2)),
                // size("S"),
                // Padding(padding: EdgeInsets.all(2)),
                // size("L"),
                //  Padding(padding: EdgeInsets.all(2)),
                // size("M"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
