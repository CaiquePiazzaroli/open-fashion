import 'package:flutter/material.dart';
import 'package:open_fashion/auth/login_page.dart';
import 'package:open_fashion/theme_data/theme_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  
  //Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      //home: const HomeTemplate(),
      home: LoginPage(),
    );
  }
}