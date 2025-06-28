import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  final List<String> _colors = [];
  final List<String> _sizes = [];

  bool isSaving = false;

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('itens').add({
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _categoryController.text.trim(),
        'imagePath': _imagePathController.text.trim(),
        'value': double.parse(_valueController.text.trim()),
        'colors': _colors,
        'sizes': _sizes,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produto adicionado com sucesso!")),
      );

      _formKey.currentState!.reset();
      _colors.clear();
      _sizes.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao adicionar o produto.")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _addColor() {
    final color = _colorController.text.trim().toLowerCase();
    if (color.isNotEmpty && !_colors.contains(color)) {
      setState(() => _colors.add(color));
      _colorController.clear();
    }
  }

  void _addSize() {
    final size = _sizeController.text.trim().toUpperCase();
    if (size.isNotEmpty && !_sizes.contains(size)) {
      setState(() => _sizes.add(size));
      _sizeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Preencha o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value == null || value.isEmpty ? 'Preencha a descrição' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (value) => value == null || value.isEmpty ? 'Preencha a categoria' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) => value == null || value.isEmpty ? 'Preencha a URL' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null ? 'Preço inválido' : null,
              ),
              const SizedBox(height: 24),

              // Cores
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: 'Adicionar Cor (em inglês)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addColor,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: _colors
                    .map((color) => Chip(
                          label: Text(color),
                          onDeleted: () => setState(() => _colors.remove(color)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Tamanhos
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Adicionar Tamanho (P, M, G...)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addSize,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: _sizes
                    .map((size) => Chip(
                          label: Text(size),
                          onDeleted: () => setState(() => _sizes.remove(size)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Botão Salvar
              ElevatedButton.icon(
                onPressed: isSaving ? null : _saveProduct,
                icon: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text("Salvar Produto"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
