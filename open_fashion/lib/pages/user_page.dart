import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_fashion/auth/login_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instância do FirebaseAuth
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Usuário atual
    User? user = auth.currentUser;

    // Dados do usuário (se estiver logado)
    String email = user?.email ?? 'Usuário não encontrado';
    String uid = user?.uid ?? '';
    String nome = user?.displayName ?? 'Sem nome';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'E-mail: $email',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'UID: $uid',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Nome: $nome',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text("Sair do app"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Após logout, volta para a tela de login (ou qualquer outra)
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
