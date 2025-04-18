//ÁREA DE IMPORTAÇÃO DAS BIBLIOTECAS
import 'package:flutter/material.dart'; //BIBLIOTECAS DO FLUTTER
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart'; //BLIBLIOTECA DE EXTRAÇÃO DAS IMAGENS
import 'dart:io'; //BIBLIOTECA PADRÃO
import 'package:Plantacheck/plant_model.dart'; //MODELO DE APRESENTAÇÃO DE APRESENTAÇÃO AS INFORMAÇÕES
import 'package:Plantacheck/services.dart'; //REFERENCIA A FUNÇÃO QUE FAZ A REQUISIÇÃO À A PI
import 'results_screen.dart';

class PhotoScreen extends StatefulWidget {

  final String adUnit = Platform.isAndroid ? 'ca-app-pub-3940256099942544/9214589741' :'8'; 

  PhotoScreen({super.key});
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  //  _loadAd();
  }
/*
  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadAd(){
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnit,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if(!mounted){
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
          onAdFailedToLoad: (ad, error){
            print("Ocorreu uma falha ao carregar: $error");
            ad.dispose();
          };
        },
      ),
    );
     bannerAd.load();
     
  }
*/
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
        MaterialPageRoute(builder: (context) => ResultsScreen(plant: plant,imageFile:_image!)),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: Colors.green,));
  }
  //BannerAd? _bannerAd;
  @override
  //INÍCIO DAS DEFINIÇÕES DA APRESENTAÇÃO DA TELA
  Widget build(BuildContext context) {
    return Scaffold( //COR DO FUNDO
      appBar: AppBar(title: const Text('Capturar ou carregar a Foto', style: TextStyle(color: Colors.green),),backgroundColor: Colors.black,),//COR DA Barra superior
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image:DecorationImage(
            image: AssetImage("lib/assets/foto-planta-SCURA.png"),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*SafeArea(
                child: SizedBox(
                  width: widget.adSize.width.toDouble(),
                  height: widget.adSize.hashCode.toDouble(),
                  child: _bannerAd == null ? const SizedBox() : AdWidget(ad: _bannerAd!),
                )
              ),*/
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
      ) : const Text('Nenhuma imagem selecionada.' ,style:TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),), //A INFORMAÇÃO QUE VAI APARECER NA TELA CASO NÃO FOR SELECIONADA NENHUMA IMAGEM
              if (_isLoading) const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.white  ,), //ENQUANTO O RESULTADO ESTIVER A CARREGAR.
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black
                ),
                onPressed: () => _identifyPlant(),
                child: const Text('Analisar',style: TextStyle(color: Colors.green
                ),), //BOTÃO PARA TIRAR A FOTO!
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black
                ),
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Tirar Foto',style: TextStyle(color: Colors.green
                ),), //BOTÃO PARA TIRAR A FOTO!
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Escolher da Galeria',style: TextStyle(color: Colors.green),), //BOTÃO PARA SELECIONAR UMA IMAGEM DA GALERIA
              ),
            ],
          ),
        ),
      ),
    );
  }
}
