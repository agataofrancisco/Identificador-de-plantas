import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:Plantacheck/plant_model.dart';

//PARTE RESPONSAVEL POR FAZER A COMUNICAÇÃO COM A API
class PlantService {
  static const String apiUrl = 'https://plant.id/api/v3/health_assessment'; //LINK
  static const String apiKey = 'ZHnzq37XZ9j0WGv4VNN17uFjD3OkpF85jw9M7UPMVQQolf6arL'; //TOKEN DA API, A CHAVE QUE AUTORIZA A BUSCA DAS INFORMAÇÕES

  static Future<PlantModel?> identifyPlant(File image, double latitude, double longitude) async {
  try {
    print('🔄 Enviando imagem para identificação...');
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    var headers = {
      'Api-Key': apiKey,
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "images": ["data:image/jpg;base64,$base64Image"],
      "latitude": latitude,
      "longitude": longitude,
      "similar_images": true
    });
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return PlantModel.fromJson(jsonResponse);
    } else {
      print('❌ Erro ao identificar planta: ${response.reasonPhrase}');
      return null;
    }
  } catch (e) {
    print('⚠ Erro inesperado: $e');
    return null;
  }
}

//gemini: AIzaSyBHerOyLIGSDQibe7PHsrm7aIq-K61j0Og
 
} 
