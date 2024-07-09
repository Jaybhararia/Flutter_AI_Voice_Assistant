import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voice_assistant/Secret_Key.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://chat-gpt26.p.rapidapi.com'),
        headers: {
          'Content-Type': 'application/json',
          'X-RapidAPI-Host': 'chat-gpt26.p.rapidapi.com',
          'X-RapidAPI-Key': secret_key,
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'Servers are busy, Come back later';
    } catch (e) {
      return 'Servers are busy, Come back later';
    }
  }
}