import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.anthropic.com/v1',
        headers: {
          'x-api-key': '${const String.fromEnvironment("ANTHROPIC_API_KEY")}',
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<String> sendChatRequest(String question) async {
    final data = {
      "model": "claude-3-5-sonnet-20241022",  // or other Claude models
      "max_tokens": 1024,
      "messages": [
        {"role": "user", "content": question}
      ]
    };

    try {
      final response = await _dio.post('/messages', data: data);

      if (response.statusCode == 200) {
        final content = response.data['content'][0]['text'];
        return content;
      } else {
        return "Request failed with status: ${response.statusCode}";
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return "AI request error: ${e.response?.statusCode}, ${e.response?.data}";
      } else {
        return "AI request error: ${e.message}";
      }
    }
  }
}
