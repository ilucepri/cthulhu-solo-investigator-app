import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JSONService {
  Future<List<String>> getStringList(String url) async {
    String jsonString = await rootBundle.loadString(url);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    List<dynamic> jsonList = jsonMap["data"];
    return jsonList.map((dynamic element) => element.toString()).toList();
  }

  Future<List<dynamic>> getObjectList(String url) async {
    String jsonString = await rootBundle.loadString(url);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap["data"] as List<dynamic>;
  }
}
