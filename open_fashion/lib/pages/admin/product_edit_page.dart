import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> initialData;

  const ProductEditPage({
    super.key,
    required this.productId,
    required this.initialData,
  });

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late TextEditingController _imagePathController;
  late TextEditingController _valueController;

  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  List<String> _colors = [];
  List<String> _sizes = [];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _nameController = TextEditingController(text: data['name'] ?? '');
    _descController = TextEditingController(text: data['description'] ?? '');
    _categoryController = TextEditingController(text: data['category'] ?? '');
    _imagePathController = TextEditingController(text: data['imagePath'] ?? '');
    _valueController = TextEditingController(text: data['value']?.toString() ?? '');
    _colors = List<String>.from(data['colors'] ?? []);
    _sizes = List<String>.from(data['sizes'] ?? []);
  }

  Future<void> _saveChanges() async {
    setState(() => isSaving = true);
    try {
      await FirebaseFirestore.instance.collection('itens').doc(widget.productId).update({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'category': _categoryController.text.trim(),
        'imagePath': _imagePathController.text.trim(),
        'value': double.tryParse(_valueController.text.trim()) ?? 0.0,
        'colors': _colors,
        'sizes': _sizes,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar o produto.')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Tem certeza que deseja excluir este produto?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Excluir")),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance.collection('itens').doc(widget.productId).delete();
      if (mounted) {
        Navigator.pop(context); // volta para lista
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto excluído com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir produto.')),
      );
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
      appBar: AppBar(title: const Text("Editar Produto")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Descrição')),
            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Categoria')),
            TextField(controller: _imagePathController, decoration: const InputDecoration(labelText: 'URL da Imagem')),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Colors
            TextField(
              controller: _colorController,
              decoration: InputDecoration(
                labelText: 'Adicionar cor',
                suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _addColor),
              ),
            ),
            Wrap(
              spacing: 8,
              children: _colors
                  .map((c) => Chip(
                        label: Text(c),
                        onDeleted: () => setState(() => _colors.remove(c)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Sizes
            TextField(
              controller: _sizeController,
              decoration: InputDecoration(
                labelText: 'Adicionar tamanho',
                suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _addSize),
              ),
            ),
            Wrap(
              spacing: 8,
              children: _sizes
                  .map((s) => Chip(
                        label: Text(s),
                        onDeleted: () => setState(() => _sizes.remove(s)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: isSaving ? null : _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text("Salvar Alterações"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _deleteProduct,
              icon: const Icon(Icons.delete),
              label: const Text("Excluir Produto"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
