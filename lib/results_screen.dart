//TELA EM QUE SÃO APRESENTADOS OS RESULTADOS DA ANÁLISE REALIZADA
import 'package:flutter/material.dart';
import 'plant_model.dart';

class ResultsScreen extends StatelessWidget {
  final PlantModel plant;

  ResultsScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, //COR DO FUNDO
      appBar: AppBar(title: Text('Resultado da Análise',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //PARTE DE APRESENTAÇÃO DAS INFOMRAÇÕES DEPENDENDO DO RESULTADOD
                Text(
                  plant.isPlant ? '✅ Isto é uma planta!' : '❌ Não é uma planta!', //FAZ UMA FERIFICAÇÃO NO RESULTADO DA VARIAVEL BOOLEANA DE QUE É UMA PLANTA OU NÃP
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (plant.isPlant) ...[
                  SizedBox(height: 8),
                  Text(
                    'Confiança: ${(plant.plantProbability * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    //VERIFICAÇÃO SE A PLANTA É SAUDAVEL OU NÃO
                    plant.isHealthy 
                      ? '🌿 A planta parece saudável!' 
                      : '⚠ A planta pode estar doente!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Saúde: ${(plant.healthProbability * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '🔍 Doenças detectadas:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (plant.diseases.where((d) => d.probability > 0.5).isEmpty)
                    Text('Nenhuma doença encontrada.'),
                  for (var disease in plant.diseases) 
                  //APRESENTA AS INFORMAAÇÕES APENAS SE O NIVEL DE PROBABILIDADE FOR MAIOR QUE 50% 
                    if (disease.probability > 0.5) ...[
                      SizedBox(height: 10),
                      Card(
                        color: Colors.green[800],
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '• ${disease.name}',
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700]
                                ),
                              ),
                              Text(
                                'Confiança: ${(disease.probability * 100).toStringAsFixed(2)}%',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              if (disease.similarImages.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      disease.similarImages.first.url, 
                                      height: 120, 
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                ],
                //BOTAO PARA VOLTAR
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Voltar', style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
