import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChatGPTService {
  static const String chatGPTApiUrl = 'https://chatgpt-42.p.rapidapi.com/gpt4';
  static const String rapidApiKey =
      '6daaf935b2mshd2a5fd46f50f50cp131ae6jsnd717f0e5a26a';
  static const String rapidApiHost = 'chatgpt-42.p.rapidapi.com';

  static const String imageUploadApiUrl =
      'https://object-detector-api1.p.rapidapi.com/ai/detect-objects';
  static const String copilotApiKey =
      '394518d717mshc5a9388640617e1p17153bjsn02b54380576a';
  static const String copilotApiHost = 'object-detector-api1.p.rapidapi.com';

  Future<String> chatGPTAPI(String prompt, {bool webAccess = false}) async {
    try {
      final response = await http.post(
        Uri.parse(chatGPTApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-RapidAPI-Key': rapidApiKey,
          'X-RapidAPI-Host': rapidApiHost,
        },
        body: jsonEncode({
          "messages": [
            {"role": "user", "content": prompt},
          ],
          "web_access": webAccess,
        }),
      );

      print('ChatGPT API Status Code: ${response.statusCode}');
      print('ChatGPT API Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['result']?.trim() ??
            'Error: Invalid response format';
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/image.png';
      File imageFile = File(filePath)..writeAsBytesSync(imageBytes);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(imageUploadApiUrl),
      );
      request.headers.addAll({
        'X-RapidAPI-Key': copilotApiKey,
        'X-RapidAPI-Host': copilotApiHost,
      });

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Upload Image Status Code: ${response.statusCode}');
      print('Upload Image Response: $responseBody');

      if (response.statusCode == 200) {
        return 'Image uploaded successfully';
      } else {
        return 'Error: ${response.statusCode} - $responseBody';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
