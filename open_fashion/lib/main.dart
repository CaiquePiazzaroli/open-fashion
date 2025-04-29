import 'package:flutter/material.dart';
import 'package:open_fashion/theme_data/theme.dart';
import 'package:open_fashion/widgets/header.dart';
import 'package:open_fashion/widgets/float_action_button.dart';
import 'package:open_fashion/widgets/bottom_navigator.dart';
import 'package:open_fashion/pages/home_page.dart';

void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeApp.getLight(),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  //index = index button clicked by the user
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List mainPages = <Widget>[
    HomePage(),
    Text("Página de perfil"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(index: _selectedIndex,),
      body: mainPages[_selectedIndex],
      floatingActionButton: FloatButton(),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}