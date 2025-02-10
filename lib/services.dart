import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plants_id/plant_model.dart';
import 'package:plants_id/results_screen.dart';

class PlantService {
  static const String apiUrl = 'https://plant.id/api/v3/health_assessment';
  static const String apiKey = '9Ju916rAX5LWYJOdwBQPFqcdw7qJ34RAN2CVi3fI86Dl3h2OUB';

  static Future<PlantModel?> identifyPlant(File image) async {
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
      "latitude": 49.207,
      "longitude": 16.608,
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

}
