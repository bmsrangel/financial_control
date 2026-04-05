import 'package:dio/dio.dart';

class GoogleSheetsService {
  GoogleSheetsService() {
    _dio = Dio();
  }

  late final Dio _dio;
  final String _spreadsheetId = '1p_8cM35U_emlMldrseG9AdxoXk_h-jj29D6nNG_D6ro';

  Future<void> addExpense({
    required String date,
    required String store,
    required String category,
    required double value,
    required String token,
  }) async {
    final url =
        "https://sheets.googleapis.com/v4/spreadsheets/$_spreadsheetId/values/A1:D1:append?valueInputOption=USER_ENTERED";
    final body = {
      "values": [
        [date, store, category, value],
      ],
    };

    await _dio.post(
      url,
      data: body,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );
  }
}
