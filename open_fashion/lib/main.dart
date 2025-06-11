import 'package:flutter/material.dart';
import 'package:open_fashion/pages/home_template.dart';
import 'package:open_fashion/theme_data/theme_settings.dart';


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
      home: const HomeTemplate(),
    );
  }
}