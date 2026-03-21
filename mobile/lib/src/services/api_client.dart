import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _http;

  ApiClient({required this.baseUrl, http.Client? client}) : _http = client ?? http.Client();

  Future<Map<String, String>> _headers({String? token}) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> getJson(String path, {String? token}) async {
    final response = await _http.get(_uri(path), headers: await _headers(token: token));
    return _decodeOrThrow(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await _http.post(
      _uri(path),
      headers: await _headers(token: token),
      body: jsonEncode(body),
    );
    return _decodeOrThrow(response);
  }

  Future<Map<String, dynamic>> deleteJson(String path, {String? token}) async {
    final response = await _http.delete(_uri(path), headers: await _headers(token: token));
    return _decodeOrThrow(response);
  }

  Map<String, dynamic> _decodeOrThrow(http.Response response) {
    final payload = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    final data = payload is Map<String, dynamic> ? payload : <String, dynamic>{};
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }
    final message = (data['message'] as String?) ?? 'Request failed (${response.statusCode})';
    throw Exception(message);
  }
}
