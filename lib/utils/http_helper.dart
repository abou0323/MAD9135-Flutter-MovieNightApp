import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpHelper {
  static String movieNightBaseUrl = 'https://movie-night-api.onrender.com';

  static startSession(String? deviceId) async {
    var response = await http
        .get(Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'));
    return jsonDecode(response.body);
  }

  static joinSession(String? deviceId, code) async {
    var response = await http.get(Uri.parse(
        '$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code'));
    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to Join Session');
    }
  }
}
