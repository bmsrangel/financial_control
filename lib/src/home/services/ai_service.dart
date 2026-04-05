import 'package:ai_edge/ai_edge.dart';

class AiService {
  final _aiEdge = AiEdge.instance;

  Future<void> init(String modelPath) async {
    await _aiEdge.initialize(
      modelPath: modelPath,
      maxTokens: 1024,
      temperature: 0.1,
    );
  }

  Future<void> createSession() async {
    await _aiEdge.createSession(temperature: 0.1);
  }

  Future<String> generateResponse(
    List<String> candidatosNomes,
    double value,
    String data,
  ) async {
    final response = await _aiEdge.generateResponse("""
  Analise os dados da nota fiscal e selecione a opção correta.

  Candidatos a Nome do Local:
  ${candidatosNomes.join('\n')}

  [TEXTO COMPLETO PARA CONTEXTO]
  $data

  Responda seguindo exclusivamente o padrão a seguir:
  Loja: (escolha o nome real da loja entre os candidatos)
  Valor: $value
  Categoria: (Alimentação, Lazer, Transporte ou Outros)
  """);
    return response;
  }

  Future<String> classifyCategory(String locationName) async {
    final prompt =
        """
Classifique o estabelecimento "$locationName" em UMA destas categorias:
- Alimentação (restaurantes, supermercados, padarias, lanchonetes)
- Lazer (livrarias, cinemas, shoppings, jogos, cultura)
- Transporte (postos de combustível, estacionamentos, uber, pedágio)
- Saúde (farmácias, hospitais, clínicas)
- Outros (qualquer coisa que não se encaixe acima)

Responda APENAS o nome da categoria exata, sem explicações.
Categoria:
""";

    try {
      String respostaIA = await _aiEdge.generateResponse(prompt);

      // Limpeza de segurança (caso a IA escreva "Categoria: Alimentação")
      String categoriaLimpa = respostaIA.replaceAll('Categoria:', '').trim();
      categoriaLimpa = categoriaLimpa.split('\n').first.trim();

      // Validação final de segurança
      final categoriasPermitidas = [
        'Alimentação',
        'Lazer',
        'Transporte',
        'Saúde',
        'Outros',
      ];
      if (categoriasPermitidas.contains(categoriaLimpa)) {
        return categoriaLimpa;
      } else {
        return "Outros"; // Fallback para não quebrar o app
      }
    } catch (e) {
      return "Outros";
    }
  }

  Future<void> close() async {
    await _aiEdge.close();
  }
}
