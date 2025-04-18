import 'dart:io';
import 'package:flutter/material.dart';
import 'plant_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ResultsScreen extends StatefulWidget {
  final PlantModel plant;
  final File imageFile;

  const ResultsScreen({super.key, required this.plant, required this.imageFile});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isLoading = false;
  String _explanation = "";

  @override
  void initState() {
    super.initState();
    Gemini.init(apiKey: 'AIzaSyBHerOyLIGSDQibe7PHsrm7aIq-K61j0Og'); // Insira sua chave de API válida
  }


//FUNÇÃO QUE RECEBE A IMAGEM E A SUA DOENÇA PARA FAZER A EXPLICAÇÃO
 void _getExplanation(String question) async {
  setState(() {
    _isLoading = true;
    _explanation = "";
  });

//ENVIO DOS DADOS NO GEMINI
  try {
    final gemini = Gemini.instance;
    final file = widget.imageFile;

    final imageBytes = await file.readAsBytes();
//A PERGUNTA NO BACKEND PARA ADJUDAR A PERSONALIZAR A RESPOSTA

    final response = await gemini.textAndImage(
      text: "A minha planta tem $question. O que causou? Como evitar? E como tratar com métodos simples? se breve, mas nem tanto, diga apenas o essencial sem falar muito. quando começares a explicar, me diz primeiro o nome da doença em portugês like 'a sua planta tem a doença $question que em portugês é (tradução))'",
      images: [imageBytes],
    );

    if (response?.content?.parts != null && response!.content!.parts!.isNotEmpty) {
      final lastPart = response.content!.parts!.last;

      // Verificando se o objeto tem um getter chamado 'text'
      if (lastPart is TextPart) {
        _explanation = lastPart.text; // Acessando o campo correto
      } else {
        _explanation = "Resposta inesperada: ${lastPart.toString()}";
      }
    } else {
      _explanation = "Resposta vazia ou inesperada.";
    }
  } catch (e) {
    setState(() {
      _explanation = "Erro ao obter explicação: $e";
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
// <- Fechamento do método corrigido

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    var diseaseWithHighestProbability = widget.plant.diseases.isNotEmpty
        ? widget.plant.diseases.reduce(
            (current, next) => current.probability > next.probability ? current : next)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da Análise', style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/foto-planta-FUNDOBRANCO.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.plant.isPlant ? '✅ Isto é uma planta!' : '❌ Não é uma planta!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (widget.plant.isPlant) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Confiança: ${(widget.plant.plantProbability * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.plant.isHealthy
                        ? '🌿 A planta parece saudável!'
                        : '⚠ A planta pode estar doente!',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Saúde: ${(widget.plant.healthProbability * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '🔍 Doenças detectadas:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (diseaseWithHighestProbability == null)
                    const Text('Nenhuma doença encontrada.'),
                  if (diseaseWithHighestProbability != null)
                    Card(
                      color: Colors.black,
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
                              '• ${diseaseWithHighestProbability.name}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                            Text(
                              'Confiança: ${(diseaseWithHighestProbability.probability * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            if (diseaseWithHighestProbability.similarImages.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    diseaseWithHighestProbability.similarImages.first.url,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                _getExplanation(diseaseWithHighestProbability.name);
                              },
                              child: const Text(
                                "Obter explicação",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(color: Colors.green),
                    ),
                  if (_explanation.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _explanation,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text('Voltar', style: TextStyle(fontSize: 18, color: Colors.green)),
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
