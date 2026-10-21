import '../errors/api_exception.dart';

class ApiConfig {
  ApiConfig({String? baseUrl})
    : baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL');

  final String baseUrl;

  Uri get baseUri {
    if (baseUrl.trim().isEmpty) {
      throw const ApiConfigurationException(
        'API_BASE_URL is not configured for this build.',
      );
    }

    final uri = Uri.tryParse(baseUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        !const {'http', 'https'}.contains(uri.scheme.toLowerCase())) {
      throw const ApiConfigurationException(
        'API_BASE_URL must be an absolute HTTP or HTTPS URL.',
      );
    }
    return uri.replace(path: '${uri.path.replaceFirst(RegExp(r'/+$'), '')}/');
  }
}
