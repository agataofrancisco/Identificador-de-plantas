
class PlantChatResponse {
  final String response;
  final double temperature;
  final String appName;

  PlantChatResponse({
    required this.response,
    required this.temperature,
    required this.appName,
  });

  factory PlantChatResponse.fromJson(Map<String, dynamic> json) {
    return PlantChatResponse(
      response: json['generated_text'] ?? 'Sem resposta',
      temperature: 0.5,
      appName: 'HuggingFace AI',
    );
  }
}