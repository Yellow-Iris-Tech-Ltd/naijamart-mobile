
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../util/cache/local.dart';
import '../../util/constants/endpoints_uri.dart';
import '../models/dashboard/txn_history_response_model.dart';
import 'package:http/http.dart' as http;


class UtilitiesRepository {
  LocalCache localCache = LocalCache();



  Future<List<Transaction>> fetchTxns(int userId) async {
    final Uri uri = Uri.parse('${NaijaMartEndpoints.transactionHistoryUrl}/$userId');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${localCache.getValue<String>('auth_token')}',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Transaction> transactions = jsonList.map((json) => Transaction.fromJson(json)).toList();
        return transactions;
      } catch (e) {
        debugPrint(e.toString());
        throw Exception("Error occurred: ${e.toString()}");
      }
    } else {
      throw Exception("Failed to fetch transactions: ${response.statusCode}");
    }
  }
}