import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/constants.dart';
import '../services/ai_service.dart';

class AiStore extends ChangeNotifier {
  AiStore() {
    _aiService = AiService();
  }

  late final AiService _aiService;

  String response = '';
  bool isLoading = false;
  String _modelPath = '';
  Map<String, dynamic> responseMap = {};

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    if (_modelPath.isEmpty) {
      final modelDirectory = await getApplicationSupportDirectory();
      final modelDirectoryPath = modelDirectory.path;
      _modelPath = join(modelDirectoryPath, modelName);
    }
    await _aiService.init(_modelPath);
    isLoading = false;
    notifyListeners();
  }

  Future<void> generateResponse(String data) async {
    isLoading = true;
    notifyListeners();
    String cleanData = data
        .replaceAll(RegExp(r'\n+'), '\n')
        .replaceAll(RegExp(r' +'), ' ')
        .trim();
    await _aiService.createSession();
    final locationName = extractLocation(cleanData);
    final total = extractTotal(data);
    final date = extractDate(data);
    final category = await _aiService.classifyCategory(locationName);
    responseMap = {
      'store': locationName,
      'total': total,
      'date': date,
      'category': category,
    };
    isLoading = false;
    notifyListeners();
  }

  String extractLocation(String ocrText) {
    // Quebra em linhas e remove linhas vazias
    final lines = ocrText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final blockedWords = [
      'CNPJ',
      'IE:',
      'CPF',
      'INSC',
      'CÓDIGO',
      'CODIGO',
      'DESCRIÇÃO',
      'DESCRICAO',
      'QTD',
      'UN',
      'VL',
      'VALOR',
      'UNIT',
      'TOTAL',
      'ITEM',
      'DOCUMENTO AUXILIAR',
      'DANFE',
      'NFC-E',
      'NF-E',
      'CUPOM FISCAL',
      'EXTRATO',
      'CONSUMIDOR',
      'RUA',
      'AVENIDA',
      'AV.',
      'PRAÇA',
      'RODOVIA',
      'ENDEREÇO',
    ];

    for (var line in lines) {
      String lineUpper = line.toUpperCase();
      if (lineUpper.length < 3) continue;
      if (lineUpper.contains(RegExp(r'\d{2}\.\d{3}'))) {
        continue; // Formato de CNPJ
      }
      bool isTrash = blockedWords.any((termo) => lineUpper.startsWith(termo));

      if (isTrash) continue;

      return line;
    }
    return "Estabelecimento Desconhecido";
  }

  String extractDate(String ocrText) {
    // O Regex busca: 2 dígitos + barra ou traço + 2 dígitos + barra ou traço + 2 ou 4 dígitos
    // Exemplos que ele acha: 10/09/20, 10/09/2020, 10-09-20
    final regex = RegExp(r'\d{2}[/-]\d{2}[/-]\d{2,4}');
    final match = regex.firstMatch(ocrText);

    if (match != null) {
      String foundDate = match.group(0)!;
      // Opcional: Você pode normalizar traços para barras aqui se quiser
      return foundDate.replaceAll('-', '/');
    }

    // Fallback inteligente: se a nota rasgou ou o OCR falhou, assumimos a data de hoje
    DateTime today = DateTime.now();
    return "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}";
  }

  double extractTotal(String ocrText) {
    // O Regex agora aceita dígitos, seguidos de vírgula OU ponto [,.]
    // O \s? aceita um espaço opcional (para o caso do "56, 00")
    // O \b garante que a captura termina ali (evita pegar fatias de códigos de barras)
    final regex = RegExp(r'\d+[,.]\s?\d{2}\b');
    final matches = regex.allMatches(ocrText);
    double highestValue = 0.0;

    for (var match in matches) {
      // Limpa os espaços (ex: "56, 00" vira "56,00" ou "56.00")
      String numStr = match.group(0)!.replaceAll(' ', '');

      // Converte qualquer vírgula que restou para ponto, que é o padrão do Dart
      numStr = numStr.replaceAll(',', '.');

      double? value = double.tryParse(numStr);

      if (value != null && value > highestValue) {
        highestValue = value;
      }
    }

    return highestValue;
  }

  Future<void> closeAi() async {
    _aiService.close();
  }
}
