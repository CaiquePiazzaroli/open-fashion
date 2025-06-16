import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_fashion/auth/login_page.dart';
import 'package:open_fashion/pages/home_template.dart';
import 'package:open_fashion/theme_data/theme_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  //Conecta com o firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool areUserLogged = false;
  const MyApp({super.key, bool? areUserLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Fashion',
      debugShowCheckedModeBanner: true,
      theme: ThemeApp.getLight(),
      home: const AuthChecker(),
    );
  }
}

//Classe para verificar o estado de autenticação
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    //authStateChanges é disparada sempre que existe um evento de login ou logout
    //Quando o login é feito, a página inicial é carregada
    //Do contrário, a tela de login é carregada
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // <<-- AQUIII
      builder: (context, snapshot) {
        // Enquanto está carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Se tiver erro
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Ocorreu um erro!'),
            ),
          );
        }

        // Se o usuário está logado
        if (snapshot.hasData) {
          return const HomeTemplate(); // Tela principal
        } else {
          return const LoginPage(); // Tela de login
        }
      },
    );
  }
}