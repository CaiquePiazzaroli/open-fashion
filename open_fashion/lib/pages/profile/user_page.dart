import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:open_fashion/pages/auth/login_page.dart';
import 'package:open_fashion/pages/profile/user_order_page.dart';
import 'package:open_fashion/widgets/camera_preview_page.dart'; // novo

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String role = '';
  String email = '';
  String uid = '';
  bool isLoading = true;
  bool isSaving = false;

  final TextEditingController _nameController = TextEditingController();

  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists && mounted) {
        final data = doc.data();
        setState(() {
          _nameController.text = data?['name'] ?? 'Sem nome';
          role = data?['role'] ?? 'comum';
          email = user.email ?? '';
          uid = user.uid;
          isLoading = false;
        });
      } else if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao carregar dados do usuário.")),
        );
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> updateUserName() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("O nome não pode estar vazio.")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': _nameController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nome atualizado com sucesso.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar o nome.")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _openCameraPreview() async {
    final cameras = await availableCameras();
    final imageFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraPreviewPage(camera: cameras.first),
      ),
    );

    if (imageFile != null && mounted) {
      setState(() {
        _capturedImage = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _openCameraPreview,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          _capturedImage != null ? FileImage(_capturedImage!) : null,
                      child: _capturedImage == null
                          ? const Icon(Icons.person, color: Colors.white, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    role == 'admin' ? 'Administrador' : 'Usuário comum',
                    style: TextStyle(
                      fontSize: 16,
                      color: role == 'admin' ? Colors.orange : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: isSaving ? null : updateUserName,
                    icon: const Icon(Icons.save),
                    label: isSaving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Salvar alterações"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserOrdersPage()),
                      );
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text("Meus Pedidos"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
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
