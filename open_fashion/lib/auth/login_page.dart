import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    
    //authStateChanges - Executa toda vez que o usuario for criado, logado ou deslogado
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            //Codigo executado sempre que o usuário se deslogar
            print('User is currently signed out!');
          } else {
            //Codigo executado sempre que o usuário logar
            print('User is signed in!');
          }
      });

    return MaterialApp(
      home: Center(
        child: Text("Pagina de login"),
      ),
    );
  }
}