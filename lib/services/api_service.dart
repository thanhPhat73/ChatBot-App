import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_consts.dart';
import '../models/chat_model.dart';
import '../models/models_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Gửi message qua Chat Completion API (GPT chat) - giữ nguyên
  static Future<List<ChatModel>> sendMessageGPT({
    required String message,
    required String modelId,
  }) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/v1/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": modelId,
          "messages": [
            {"role": "user", "content": message}
          ]
        }),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      log("sendMessageGPT response: $jsonResponse");

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      if (jsonResponse["choices"] == null || jsonResponse["choices"].isEmpty) {
        log("Không tìm thấy lựa chọn nào ");
        return [];
      }

      List<ChatModel> chatList = List.generate(
        jsonResponse["choices"].length,
            (index) => ChatModel(
          msg: jsonResponse["choices"][index]["message"]["content"] ?? "",
          chatIndex: 1,
        ),
      );

      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Gửi message qua Text Completion API (prompt + completion) - SỬA lại theo API đoạn code 2
  static Future<List<ChatModel>> sendMessage({
    required String message,
    required String modelId,
  }) async {
    try {
      log("modelId $modelId");
      var response = await http
          .post(
        Uri.parse("https://aiscanner.tech/api/server/chat"),
        headers: {
          'Authorization': 'Bearer ff22ee3e-908c-4237-a14b-b9ba56b6769c',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": modelId,
          "prompt": message,
        }),
      )
          .timeout(const Duration(seconds: 60)); // timeout 60s

      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      log("sendMessage response: $jsonResponse");

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      if (jsonResponse["data"] == null ||
          jsonResponse["data"]["choices"] == null ||
          (jsonResponse["data"]["choices"] as List).isEmpty) {
        log("No choices found or empty choices in sendMessage response");
        return [];
      }

      List<ChatModel> chatList = List.generate(
        (jsonResponse["data"]["choices"] as List).length,
            (index) => ChatModel(
          msg: jsonResponse["data"]["choices"][index]["text"] ?? "",
          chatIndex: 1,
        ),
      );

      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
