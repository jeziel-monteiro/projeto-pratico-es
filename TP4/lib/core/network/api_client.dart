import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient, this.config = ApiConfig.fromEnvironment})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  final ApiConfig config;

  Future<Object?> getJson(
    String path, {
    Map<String, Object?>? queryParameters,
    String? bearerToken,
    Map<String, String>? headers,
  }) async {
    final response = await _send(
      () => _httpClient.get(
        config.endpoint(path, queryParameters: queryParameters),
        headers: _headers(bearerToken, headers),
      ),
    );

    return _decode(response);
  }

  Future<Object?> postJson(
    String path, {
    Object? body,
    String? bearerToken,
    Map<String, String>? headers,
  }) async {
    final response = await _send(
      () => _httpClient.post(
        config.endpoint(path),
        headers: _headers(bearerToken, headers),
        body: jsonEncode(body ?? <String, Object?>{}),
      ),
    );

    return _decode(response);
  }

  Future<Object?> deleteJson(
    String path, {
    String? bearerToken,
    Map<String, String>? headers,
  }) async {
    final response = await _send(
      () => _httpClient.delete(
        config.endpoint(path),
        headers: _headers(bearerToken, headers),
      ),
    );

    return _decode(response);
  }

  void close() {
    _httpClient.close();
  }

  Map<String, String> _headers(
    String? bearerToken,
    Map<String, String>? extraHeaders,
  ) {
    return {
      'accept': 'application/json',
      'content-type': 'application/json',
      if (bearerToken != null && bearerToken.isNotEmpty)
        'authorization': 'Bearer $bearerToken',
      ...?extraHeaders,
    };
  }

  Object? _decode(http.Response response) {
    final bodyText = utf8.decode(response.bodyBytes);
    final Object? body = bodyText.isEmpty ? null : jsonDecode(bodyText);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: _messageFrom(body),
        body: body,
      );
    }

    return body;
  }

  String _messageFrom(Object? body) {
    return switch (body) {
      {'message': final String message} => message,
      {'error': final String error} => error,
      _ => 'Falha ao comunicar com a API Porto Certo.',
    };
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException(
        statusCode: 0,
        message:
            'Tempo esgotado ao conectar com a API Porto Certo. Verifique se o backend está rodando e se o celular está na mesma rede.',
      );
    } on http.ClientException {
      throw const ApiException(
        statusCode: 0,
        message:
            'Não foi possível conectar com a API Porto Certo. No celular, use o IP local do computador em vez de localhost.',
      );
    }
  }
}
