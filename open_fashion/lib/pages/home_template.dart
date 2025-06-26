import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_fashion/pages/admin/admin_page.dart';
import 'package:open_fashion/pages/store/banner_page.dart';
import 'package:open_fashion/pages/navigation/drawer_page.dart';
import 'package:open_fashion/pages/store/shop_page.dart';
import 'package:open_fashion/pages/profile/user_page.dart';
import 'package:open_fashion/widgets/bottom_navigator_widget.dart';
import 'package:open_fashion/widgets/float_action_button_widget.dart';
import 'package:open_fashion/widgets/header_widget.dart';

class HomeTemplate extends StatefulWidget {
  //Pode ou não ser passado na instância da main
  final int? categoryGrid;

  //Construtor da Main
  const HomeTemplate({super.key, this.categoryGrid});
  
  @override
  State<HomeTemplate> createState() => _HomeTemplate();
}

class _HomeTemplate extends State<HomeTemplate> {
  //Controla a exibição das páginas pelo bottomNav
  late int _selectedIndex = 0;

  //Irá receber o categoryGrid
  late int? categoryId;

  bool isAdmin = false;

  //Irá receber as páginas que serão renderizadas
  late List<Widget> mainPages;

  String? uid = FirebaseAuth.instance.currentUser?.uid;

  //Chamado uma unica vez quando o widget é carregado - Inicializa as variaveis
  @override
  void initState() {
    super.initState();

    //Inicia categoryID com o categoryGrid
    categoryId = widget.categoryGrid;

    //Setando o valor inicial de selectedIndex
    _selectedIndex = (categoryId != null ? 1 : 0); 

    //Iniciando a lista de páginas
    mainPages = [
      BannerPage(),
      ShopPage(),
      UserPage(),
    ];

     findUserData(); // Buscar tipo de usuário ao iniciar
  }

  Future<void> findUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data?['role'] == 'admin') {
          setState(() {
            isAdmin = true;
            mainPages.add(AdminPage());
          });
        }
      }
    } else {
      print("Usuário não está logado.");
    }
  }

  //Executa quando o usuario clica em um botao do bottomNav
  void _onItemTapped(int index) {

    //index = indice do elemento clicado 
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
        isAdmin: isAdmin,
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
