import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_fashion/pages/auth/login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String name = '';
  String role = '';
  String email = '';
  String uid = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Usuário não logado, navega para LoginPage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && mounted) {
        final data = doc.data();
        setState(() {
          name = data?['name'] ?? 'Sem nome';
          role = data?['role'] ?? 'comum';
          email = user.email ?? '';
          uid = user.uid;
          isLoading = false;
        });
      } else if (mounted) {
        // Caso o documento não exista, configura isLoading false
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao carregar dados do usuário.")),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(
                    role == 'admin' ? 'Administrador' : 'Usuário comum',
                    style: TextStyle(
                      fontSize: 16,
                      color: role == 'admin' ? Colors.orange : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      title: const Text("Email"),
                      subtitle: Text(email),
                      leading: const Icon(Icons.email),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      title: const Text("UID"),
                      subtitle: Text(uid),
                      leading: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Sair do app"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
