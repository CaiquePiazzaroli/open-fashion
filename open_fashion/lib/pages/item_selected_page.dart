import 'package:flutter/material.dart';
import 'package:open_fashion/mocks/detail_page_itens.dart';
import 'package:open_fashion/widgets/color_button_widget.dart';
import 'package:open_fashion/widgets/size_button_widget.dart';

class ItemSelectedPage extends StatelessWidget {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle priceStyle = TextStyle(
    fontSize: 28,
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
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        color: Colors.black,
        child: TextButton(
          onPressed: () => {},
          child: Text("+ ADD CART", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: screenSize,
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        width: screenSize - 32,
                        alignment: Alignment.center,
                        itemSelected['imagepath'],
                      ),
                    ],
                  ),
                  Row(children: [Text(itemSelected['title'], style: titleStyle)]),
                  Row(children: [Text(itemSelected['subtitle'],style: TextStyle(fontSize: 18))]),
                  Row(children: [Text("R\$${itemSelected['price']}", style: priceStyle)]),
                  colorAndSize(itemSelected, attributeVariants),
                ],
              ),
            ),
        ),
      ]),
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

  Wrap colorAndSize(Map itemSelected, Map attributeVariants) {
    return Wrap(
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text("Cores:"),
              ),
              //Errado: attributeVariants['colors'].map((attribute) => {Text(attribute)})
              ...attributeVariants['colors'].map((colorString) => ColorButtonWidget(colorName: colorString)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(4)),
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Text("Tamanho"),
              ),
              //Itera sobre a lista de tamanhos disponíveis e cria um SizeButtonWidget para cada tamanho
              ...attributeVariants['sizes'].map(
                (sizeString) => SizeButtonWidget(size: sizeString),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
