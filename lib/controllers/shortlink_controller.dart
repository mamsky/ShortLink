import 'package:fluttergo/models/api_service.dart';

class ShortlinkController {
  static Future<String> generateShortLink(String longUrl) async {
    try {
      final response = await ApiService.post(
        '/shorten',
        body: {'url': longUrl},
      );
      if (response['url'] != null) {
        return response['url'];
      } else {
        throw Exception('Shortening failed: ${response}');
      }
    } catch (e) {
      throw Exception('Error generating short URL: $e');
    }
  }
}
