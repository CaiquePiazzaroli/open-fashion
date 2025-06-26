import 'package:flutter/material.dart';
import 'package:open_fashion/pages/home_template.dart';


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String phoneNumber = "(786) 713-8616";

  List<List> itensList = [
    <Map>[
      {"name": "New", "id": 1},
      {"name": "Apareal", "id": 2},
      {"name": "Bag", "id": 3},
      {"name": "Shoes", "id": 4},
      {"name": "Beauty", "id": 5},
      {"name": "Acessories", "id": 6},
    ],
    <Map>[
      {"name": "New", "id": 7},
      {"name": "Apareal", "id": 8},
      {"name": "Man", "id": 9},
    ],
    <Map>[
      {"name": "New", "id": 10},
      {"name": "Kids", "id": 11},
    ],
  ];

  var _indexMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      child: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: () => {Navigator.of(context).pop()},
                icon: Text("X"),
              ),
            ],
          ),
          gender(), //Generos (woman, man, kids)
          categories(context), //Categorias de roupas
          contact(), //Contato e localização
          social(), //Redes sociais
        ],
      ),
    );
  }

  SizedBox contact() {
    return SizedBox(
          height: 120,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => {},
                    icon: Image.asset('assets/Call.png'),
                  ),
                  Text(phoneNumber),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => {},
                    icon: Image.asset('assets/Location.png'),
                  ),
                  Text("Store Location"),
                ],
              ),
            ],
          ),
        );
  }

  SizedBox categories(BuildContext context) {
    return SizedBox(
          height: 400,
          child: Column(
            children: [
              ...itensList[_indexMenu].map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      HomeTemplate(categoryGrid: item['id']),
                            ),
                          );
                        },
                        child: Text(item['name']),
                      ),
                    ],
                  ),
                ),
              ), //... para distribuir os itens na children
            ],
          ),
        );
  }

  SizedBox gender() {
    return SizedBox(
          height: 50,
          child: Row(
            children: [
              TextButton(
                onPressed:
                    () => {
                      setState(() {
                        _indexMenu = 0;
                      }),
                    },
                child: const Text("WOMEN"),
              ),
              TextButton(
                onPressed:
                    () => {
                      setState(() {
                        _indexMenu = 1;
                      }),
                    },
                child: const Text("MEN"),
              ),
              TextButton(
                onPressed:
                    () => {
                      setState(() {
                        _indexMenu = 2;
                      }),
                    },
                child: const Text("KIDS"),
              ),
            ],
          ),
        );
  }

  SizedBox social() {
    return SizedBox(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/Divider.png')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => {print("Social")},
                    icon: Image.asset('assets/Twitter.png'),
                  ),
                  IconButton(
                    onPressed: () => {print("Social")},
                    icon: Image.asset('assets/Instagram.png'),
                  ),
                  IconButton(
                    onPressed: () => {print("Social")},
                    icon: Image.asset('assets/yt.png'),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}
