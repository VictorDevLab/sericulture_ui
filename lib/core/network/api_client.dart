import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../errors/api_exception.dart';

class ApiClient {
  ApiClient({required ApiConfig config, http.Client? client})
    : _baseUri = config.baseUri,
      _client = client ?? http.Client();

  final Uri _baseUri;
  final http.Client _client;

  Future<Object?> request({
    required String method,
    required String path,
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    Object? body,
  }) async {
    final uri = _baseUri
        .resolve(path.replaceFirst(RegExp(r'^/+'), ''))
        .replace(
          queryParameters: queryParameters.isEmpty ? null : queryParameters,
        );
    final request = http.Request(method.toUpperCase(), uri)
      ..headers.addAll(headers);
    if (body != null) {
      request.headers.putIfAbsent('content-type', () => 'application/json');
      request.body = jsonEncode(body);
    }

    try {
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          message: 'The server returned an unsuccessful response.',
          statusCode: response.statusCode,
        );
      }
      if (response.statusCode == 204 || response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } on FormatException {
        throw const ApiException(
          message: 'The server response was not valid JSON.',
        );
      }
    } on http.ClientException {
      throw const ApiException(message: 'The server could not be reached.');
    }
  }

  void close() => _client.close();
}
