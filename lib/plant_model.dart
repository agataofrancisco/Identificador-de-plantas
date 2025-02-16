
  //PARTE RESPONSAVEL POR RECEBER OS DADOS QUE FPREM RECEBIDOS DA API E ARMAZENÁ-LOS EM VARIAVEIS
class PlantModel {
  final bool isPlant;
  final double plantProbability;
  final bool isHealthy;
  final double healthProbability;
  final List<DiseaseSuggestion> diseases;

  PlantModel({
    required this.isPlant,
    required this.plantProbability,
    required this.isHealthy,
    required this.healthProbability,
    required this.diseases,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    final result = json['result'];

    // Verificar se é uma planta
    final isPlant = result['is_plant']['binary'] ?? false;
    final plantProbability = result['is_plant']['probability']?.toDouble() ?? 0.0;

    // Verificar se está saudável
    final isHealthy = result['is_healthy']['binary'] ?? false;
    final healthProbability = result['is_healthy']['probability']?.toDouble() ?? 0.0;

    // Listar possíveis doenças
    List<DiseaseSuggestion> diseases = [];
    if (result['disease']?['suggestions'] != null) {
      diseases = (result['disease']['suggestions'] as List)
          .map((d) => DiseaseSuggestion.fromJson(d))
          .toList();
    }

    return PlantModel(
      isPlant: isPlant,
      plantProbability: plantProbability,
      isHealthy: isHealthy,
      healthProbability: healthProbability,
      diseases: diseases,
    );
  }
}

//PARTE RESPONSAVEL POR RECEBER A PARTE ESPECIFICA DAS DOENCAS QUE A PLANTA TEM
class DiseaseSuggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;

  DiseaseSuggestion({
    required this.id,
    required this.name,
    required this.probability,
    required this.similarImages,
  });

  factory DiseaseSuggestion.fromJson(Map<String, dynamic> json) {
    List<SimilarImage> images = [];
    if (json['similar_images'] != null) {
      images = (json['similar_images'] as List)
          .map((img) => SimilarImage.fromJson(img))
          .toList();
    }

    return DiseaseSuggestion(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Desconhecido',
      probability: json['probability']?.toDouble() ?? 0.0,
      similarImages: images,
    );
  }
}
//PARTE QUE LIDA COM AS IMAGENS SIMILARES À DOENÇA
class SimilarImage {
  final String url;
  final double similarity;

  SimilarImage({required this.url, required this.similarity});

  factory SimilarImage.fromJson(Map<String, dynamic> json) {
    return SimilarImage(
      url: json['url'] ?? '',
      similarity: json['similarity']?.toDouble() ?? 0.0,
    );
  }
}
