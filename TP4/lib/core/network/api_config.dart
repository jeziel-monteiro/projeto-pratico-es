class ApiConfig {
  const ApiConfig({required this.baseUrl});

  static const fromEnvironment = ApiConfig(
    baseUrl: String.fromEnvironment(
      'PORTO_CERTO_API_BASE_URL',
      defaultValue: 'http://localhost:3000/api/v1',
    ),
  );

  final String baseUrl;

  Uri endpoint(String path, {Map<String, Object?>? queryParameters}) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final uri = Uri.parse(normalizedBase).resolve(normalizedPath);

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParameters.map((key, value) => MapEntry(key, '$value')),
      },
    );
  }
}
