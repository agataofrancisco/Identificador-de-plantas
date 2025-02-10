  import 'package:flutter/material.dart';
  import 'plant_model.dart';

  class ResultsScreen extends StatelessWidget {
  final PlantModel plant;

  ResultsScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado da Análise')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                plant.isPlant ? '✅ Isto é uma planta!' : '❌ Não é uma planta!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Confiança: ${(plant.plantProbability * 100).toStringAsFixed(2)}%'),
              SizedBox(height: 20),
              Text(
                plant.isHealthy ? '🌿 A planta parece saudável!' : '⚠ A planta pode estar doente!',
                style: TextStyle(fontSize: 20),
              ),
              Text('Saúde: ${(plant.healthProbability * 100).toStringAsFixed(2)}%'),
              SizedBox(height: 20),
              Text('🔍 Doenças detectadas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (plant.diseases.isEmpty)
                Text('Nenhuma doença identificada.'),
              for (var disease in plant.diseases) ...[
                SizedBox(height: 10),
                Text('• ${disease.name} (Confiança: ${(disease.probability * 100).toStringAsFixed(2)}%)'),
                if (disease.similarImages.isNotEmpty)
                  Image.network(disease.similarImages.first.url, height: 100),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
