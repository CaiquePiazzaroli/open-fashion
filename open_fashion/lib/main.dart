import 'package:flutter/material.dart';
import 'package:open_fashion/pages/shop_page.dart';
import 'package:open_fashion/theme_data/theme_settings.dart';
import 'package:open_fashion/pages/drawer_page.dart';
import 'package:open_fashion/widgets/header_widget.dart';
import 'package:open_fashion/widgets/float_action_button_widget.dart';
import 'package:open_fashion/widgets/bottom_navigator_widget.dart';
import 'package:open_fashion/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Fashion',
      debugShowCheckedModeBanner: true,
      theme: ThemeApp.getLight(),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  //Pode ou não ser passado na instância da main
  final int? categoryGrid;

  //Construtor da Main
  const Main({super.key, this.categoryGrid});
  
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  //Controla a exibição das páginas pelo bottomNav
  late int _selectedIndex = 0;

  //Irá receber o categoryGrid
  late int? categoryId;

  //Irá receber as páginas que serão renderizadas
  late List<Widget> mainPages;

  //Chamado uma unica vez quando o widget é carregado - Inicializa as variaveis
  @override
  void initState() {
    super.initState();

    //Inicia categoryID com o categoryGrid
    categoryId = widget.categoryGrid;

    //Setando o valor inicial de selectedIndex
    _selectedIndex = categoryId != null ? 1 : 0; 

    //Iniciando a lista de páginas
    mainPages = [
      HomePage(),
      ShopPage(category: categoryId),
      Center(child: Text("Página de perfil")),
    ];
  }

  //Executa quando o usuario clica em um botao do bottomNav
  void _onItemTapped(int index) {

    //index = indice do elemento clicado na lista
    print(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: HeaderWidget(),
      body: mainPages[_selectedIndex],
      floatingActionButton: FloatButton(),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
