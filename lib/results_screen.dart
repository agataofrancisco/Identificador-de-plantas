/*//TELA EM QUE SÃO APRESENTADOS OS RESULTADOS DA ANÁLISE REALIZADA
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:plants_id/services.dart';
import 'plant_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'plantchatmodel.dart';

class ResultsScreen extends StatefulWidget {
  final PlantModel plant;
  final File imageFile;
  ResultsScreen({required this.plant, required this.imageFile,}); // Construtor correto

  @override
  _ResultsScreenState createState() => _ResultsScreenState(imageFile: imageFile);
}

class _ResultsScreenState extends State<ResultsScreen> {
  final File imageFile;
_ResultsScreenState({required this.imageFile});
  bool _isLoading = false;
  String _explanation = "";
  PlantChatResponse? chat;

@override
void initState() {
  super.initState();
  Gemini.init(apiKey: 'AIzaSyBHerOyLIGSDQibe7PHsrm7aIq-K61j0Og'); // Insira sua chave de API válida
}
  
void _getExplanation(String question,) async {
  setState(() {
    _isLoading = true;
    _explanation = "";
  });

  try {
    final gemini = Gemini.instance;
    final file = File(imageFile.path); // Converte XFile para File

    final response = await gemini.textAndImage(
      text: "A minha planta tem $question. O que causou? Como evitar? E como tratar com métodos simples?",
      images: [file.readAsBytesSync()], // Lê a imagem em bytes
    );

    setState(() {
      _explanation = response?.content?.parts?.last.toString() ?? "Sem resposta disponível.";
    });
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

void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: Colors.green,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado da Análise',style: TextStyle(color: Colors.green),),backgroundColor: Colors.black,),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
           image: DecorationImage(
            image: AssetImage("lib/assets/foto-planta-FUNDOBRANCO.jpg"),fit: BoxFit.cover),
            
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //PARTE DE APRESENTAÇÃO DAS INFOMRAÇÕES DEPENDENDO DO RESULTADOD
                Text(
                  widget.plant.isPlant ? '✅ Isto é uma planta!' : '❌ Não é uma planta!', //FAZ UMA FERIFICAÇÃO NO RESULTADO DA VARIAVEL BOOLEANA DE QUE É UMA PLANTA OU NÃP
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (widget.plant.isPlant) ...[
                  SizedBox(height: 8),
                  Text(
                    'Confiança: ${(widget.plant.plantProbability * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    //VERIFICAÇÃO SE A PLANTA É SAUDAVEL OU NÃO
                    widget.plant.isHealthy 
                      ? '🌿 A planta parece saudável!' 
                      : '⚠ A planta pode estar doente!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Saúde: ${(widget.plant.healthProbability * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '🔍 Doenças detectadas:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (widget.plant.diseases.where((d) => d.probability > 0.5).isEmpty)
                    Text('Nenhuma doença encontrada.'),
                  for (var disease in widget.plant.diseases) 
                  //APRESENTA AS INFORMAAÇÕES APENAS SE O NIVEL DE PROBABILIDADE FOR MAIOR QUE 50% 
                    if (disease.probability > 0.7) ...[
                      SizedBox(height: 10),
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
                                '• ${disease.name}',
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700]
                                ),
                              ),
                              Text(
                                'Confiança: ${(disease.probability * 100).toStringAsFixed(2)}%',
                                style: TextStyle(fontSize: 16, color: Colors.green),
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black
                                  ),
                                  onPressed: (){_getExplanation(disease.name);},
                                  child: Text("Obter explicação", style: TextStyle(color: Colors.green),)
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                ],
                if(_isLoading)Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(color: Colors.green,),
                ),
                if (_explanation != null) 
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),                        
                          ),
                        ),
                      ),
                    ),
                  ),

                //BOTAO PARA VOLTAR
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Voltar', style: TextStyle(fontSize: 18,color: Colors.green)),
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

}
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plants_id/services.dart';
import 'plant_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ResultsScreen extends StatefulWidget {
  final PlantModel plant;
  final File imageFile;

  ResultsScreen({required this.plant, required this.imageFile});

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

  void _getExplanation(String question) async {
  setState(() {
    _isLoading = true;
    _explanation = "";
  });

  try {
    final gemini = Gemini.instance;
    final file = widget.imageFile;

    if (file == null) {
      setState(() {
        _explanation = "Erro: Nenhuma imagem foi fornecida.";
      });
      return;
    }

    final imageBytes = await file.readAsBytes();

    final response = await gemini.textAndImage(
      text: "A minha planta tem $question. O que causou? Como evitar? E como tratar com métodos simples? se breve, mas nem tanto, diga apenas o essencial sem falar muito",
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultado da Análise',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
                  widget.plant.isPlant
                      ? '✅ Isto é uma planta!'
                      : '❌ Não é uma planta!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (widget.plant.isPlant) ...[
                  SizedBox(height: 8),
                  Text(
                    'Confiança: ${(widget.plant.plantProbability * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.plant.isHealthy
                        ? '🌿 A planta parece saudável!'
                        : '⚠ A planta pode estar doente!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Saúde: ${(widget.plant.healthProbability * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '🔍 Doenças detectadas:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (widget.plant.diseases.where((d) => d.probability > 0.5).isEmpty)
                    Text('Nenhuma doença encontrada.'),
                  for (var disease in widget.plant.diseases)
                    if (disease.probability > 0.7) ...[
                      SizedBox(height: 10),
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
                                '• ${disease.name}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[700]),
                              ),
                              Text(
                                'Confiança: ${(disease.probability * 100).toStringAsFixed(2)}%',
                                style: TextStyle(fontSize: 16, color: Colors.green),
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
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  _getExplanation(disease.name);
                                },
                                child: Text(
                                  "Obter explicação",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                ],
                if (_isLoading)
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
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
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Voltar', style: TextStyle(fontSize: 18, color: Colors.green)),
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
