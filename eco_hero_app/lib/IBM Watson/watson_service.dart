import 'package:http/http.dart' as http;
import 'dart:convert';

class WatsonService {
  final String apiKey = 'YOUR_API_KEY';
  final String url = 'YOUR_SERVICE_URL';
  final String assistantId = 'YOUR_ASSISTANT_ID';
  final String environmentId = 'YOUR_ENVIRONMENT_ID';
  final String version = '2023-08-07';

  Future<String> sendMessage(String message, String userId) async {
    final endpoint = '$url/v2/assistants/$assistantId/environments/$environmentId/message?version=$version';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('apikey:$apiKey'))}',
    };

    final body = jsonEncode({
      'input': {
        'message_type': 'text',
        'text': message,
      },
      'user_id': userId,
    });

    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final watsonReply = data['output']['generic'][0]['text'];
      return watsonReply;
    } else {
      throw Exception('Failed to communicate with Watson Assistant: ${response.statusCode}');
    }
  }
}
