//ÁREA DE IMPORTAÇÃO DAS BIBLIOTECAS
import 'package:flutter/material.dart'; //BIBLIOTECAS DO FLUTTER
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart'; //BLIBLIOTECA DE EXTRAÇÃO DAS IMAGENS
import 'package:plants_id/localizador.dart';
import 'dart:io'; //BIBLIOTECA PADRÃO
import 'package:plants_id/plant_model.dart'; //MODELO DE APRESENTAÇÃO DE APRESENTAÇÃO AS INFORMAÇÕES
import 'package:plants_id/services.dart'; //REFERENCIA A FUNÇÃO QUE FAZ A REQUISIÇÃO À A PI
import 'results_screen.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File? _image;
  bool _isLoading = false;
//FUNÇÃO PARA PEGAR A LOCALIZAÇÃO ACTUAL:
Future<Position> _getPosition() async {
  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  }

  // Após garantir que as permissões foram concedidas, verificamos se os serviços estão ativados
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  return await Geolocator.getCurrentPosition();
}

//FUNÇÃO QUE PEGA AS IMAGENS USANDO A BIBLIOTECA IMPORTADA
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    setState(() => _image = File(pickedFile.path));
  }

//FUNÇÃO QUE RETORNA OS RESULTADOS CASO EXISTAM NA API
  Future<void> _identifyPlant() async {
  if (_image == null) {
    _showError('Nenhuma imagem selecionada.');
    return;
  }

  setState(() => _isLoading = true);

  try {
    // Obtém a posição atual
    Position position = await _getPosition();
    double latitude = position.latitude;
    double longitude = position.longitude;

    // Chama o serviço de identificação da planta com a imagem e localização
    PlantModel? plant = await PlantService.identifyPlant(_image!, latitude, longitude);

    if (plant != null) {
      // Se a API retornar informações da planta, abre a tela de resultado
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultsScreen(plant: plant,)),
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
  //INÍCIO DAS DEFINIÇÕES DA APRESENTAÇÃO DA TELA
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, //COR DO FUNDO
      appBar: AppBar(title: Text('Capturar ou carregar a Foto', style: TextStyle(color: Colors.white),), backgroundColor: Colors.green,),//COR DA Barra superior
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           _image != null 
  ? Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect( // Garante o arredondamento da imagem
        borderRadius: BorderRadius.circular(20), // Ajuste do BorderRadius
        child: Container(
          height: MediaQuery.of(context).size.width * 0.9, // Quadrado baseado na largura
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Borda arredondada
            color: Colors.grey[300], // Fundo para caso a imagem não preencha tudo
          ),
          child: Image.file(
            _image!,
            fit: BoxFit.cover, // Garante que a imagem preencha o quadrado sem deformar
          ),
        ),
      ),
    ) 
  
: Text('Nenhuma imagem selecionada.' ,style:TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),), //A INFORMAÇÃO QUE VAI APARECER NA TELA CASO NÃO FOR SELECIONADA NENHUMA IMAGEM
            if (_isLoading) Padding(
              padding: const EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Colors.white  ,), //ENQUANTO O RESULTADO ESTIVER A CARREGAR.
            ),
            ElevatedButton(
              onPressed: () => _identifyPlant(),
              child: Text('Analisar',style: TextStyle(color: Colors.green
              ),), //BOTÃO PARA TIRAR A FOTO!
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Tirar Foto',style: TextStyle(color: Colors.green
              ),), //BOTÃO PARA TIRAR A FOTO!
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Escolher da Galeria',style: TextStyle(color: Colors.green),), //BOTÃO PARA SELECIONAR UMA IMAGEM DA GALERIA
            ),
           
          ],
        ),
      ),
    );
  }
}
