import 'package:flutter/material.dart';

import '../../core/stores/auth_store.dart';
import '../services/google_sheets_service.dart';

class GoogleSheetsStore extends ChangeNotifier {
  GoogleSheetsStore(this._googleSheetsService, this._authStore);

  final GoogleSheetsService _googleSheetsService;
  final AuthStore _authStore;

  Future<void> addDataToSheet(Map<String, dynamic> data) async {
    final token = _authStore.getToken();
    if (token != null) {
      await _googleSheetsService.addExpense(
        date: data['date'],
        store: data['store'],
        category: data['category'],
        value: data['total'],
        token: token,
      );
    }
  }
}
