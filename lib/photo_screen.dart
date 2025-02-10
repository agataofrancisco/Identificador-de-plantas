import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:plants_id/plant_model.dart';
import 'package:plants_id/services.dart';
import 'results_screen.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    setState(() => _image = File(pickedFile.path));

    _identifyPlant();
  }

  Future<void> _identifyPlant() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      PlantModel? plant = await PlantService.identifyPlant(_image!);

      if (plant != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsScreen(plant: plant)),
        );
      } else {
        _showError('Erro ao identificar a planta. Tente novamente.');
      }
    } catch (e) {
      _showError('Ocorreu um erro inesperado: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capturar ou Upload de Foto')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!) : Text('Nenhuma imagem selecionada.'),
            if (_isLoading) Padding(
              padding: const EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Tirar Foto'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Escolher da Galeria'),
            ),
          ],
        ),
      ),
    );
  }
}
